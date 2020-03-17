from copy import deepcopy
from functools import partial
from subprocess import run
from sys import exit

import numpy

from iterscheme import IterationSchemeElement as ISE, IterationScheme as IS, \
                       NoConstants, Constants, named_parameter, namedtuple_adapter
from utils import prepare_config


def _compute_substitutions(subs_history, v):  # v for variables

    if v.phase not in 'i':
        print("Wrong phase - {}!".format(phase))
        exit(1)

    subs = {}

    alpha1 = 3.8 * (v.t - 479.0) * 10.0**(-4) 
    alpha3 = 3.8 * (v.t - 479.0) * 10.0**(-4)
    alpha11 = -0.73 * 10**(-1)
    alpha12 = 7.5 * 10**(-1)
    alpha111 = 2.6 * 10**(-1)
    alpha112 = 6.1 * 10**(-1)
    alpha123 = -37.0 * 10**(-1)
    Q11 = 0.089 
    Q12 = -0.026
    Q44 = 0.0675 
    s11 = 8.0 * 10.0**(-3)
    s12 = -2.5 * 10.0**(-3)
    s44 = 9.0 * 10.0**(-3)
    
    alpha1_star = alpha1 - v.um * ( (Q11 + Q12) / (s11 + s12) )
    alpha3_star = alpha1 - v.um * ( (2.0 * Q12) / (s11 + s12) )
    alpha11_star = ( alpha11 + 0.5 * ( 1.0 / (s11**2.0 - s12**2.0) ) *
                            ( s11*(Q11**2.0 + Q12**2.0) - 2.0*Q11*Q12*s12 ) )
    alpha33_star = ( alpha11 + ( (Q12**2.0) / (s11 + s12) ) )
    alpha13_star = ( alpha12 + ( Q12*(Q11 + Q12) / (s11 + s12) ) )
    alpha12_star = ( alpha12 - ( 1.0 / (s11**2.0 - s12**2.0) ) *
                            ( s12*(Q11**2.0 + Q12**2.0) - 2.0*Q11*Q12*s11 ) +
                            ( (Q44**2.0) / (2.0*s44) ) )

    subs['alpha1'] = "'{} {}'".format(alpha1_star, alpha3_star)
    subs['alpha11'] = "'{} {}'".format(alpha11_star, alpha33_star)
    subs['alpha12'] = "'{} {}'".format(alpha12_star, alpha13_star)
    subs['alpha111'] = alpha111
    subs['alpha112'] = alpha112
    subs['alpha123'] = alpha123

    subs['G110']      = 0.173
    subs['G11_G110']  = 1.6
    subs['G12_G110']  = 0
    subs['G44_G110']  = 0.8
    subs['G44P_G110'] = 0.8

    subs['eps_0'] = 8.85 * 10**(-3)
    subs['eps_i'] = 10.0
    subs['eps_p'] = 1.0
    subs['permittivity_electrostatic_ferro'] = subs['eps_0'] * subs['eps_i']
    subs['permittivity_electrostatic_para'] = subs['eps_0'] * subs['eps_p']
    
    subs['up_pot'] = v.dpot / 2.0
    subs['bottom_pot'] = -v.dpot / 2.0

    subs['polar_x_value_min'], subs['polar_x_value_max'], \
    subs['polar_y_value_min'], subs['polar_y_value_max'], \
    subs['polar_z_value_min'], subs['polar_z_value_max'] = {
        'i' : (-1e-5, 1e-5, -1e-5, 1e-5, -1e-5, 1e-5),
    }[v.phase]
    
    subs['lscale']     = 1.0
    subs['time_scale'] = 1.0
    
    subs['filebase'] = f't_{v.t}_radius_{v.radius}_thickness_{v.thickness}_um_{v.um}'

    subs['mesh_name'] = f'tablet_r_{v.radius}_th_{v.thickness}.msh'
    
    if v.needprev:
        subs['active_ics'] = "'pxic pyic pzic potic'"
        subs['active_funcs'] = "'pxf pyf pzf potf'" 
        subs['active_user_objects'] = "'soln kill'"
        subs['previous_sim'] = f"'{subs_history[-1]['previous_sim_name']}.e'"
    else:
        subs['active_ics'] = "'ic_polar_x_ferro_random ic_polar_y_ferro_random ic_polar_z_ferro_random'"
        subs['active_funcs'] = "''"
        subs['active_user_objects'] = "'kill'"
        subs['previous_sim'] = 'none_prev_sim.e'
        
    subs_history.append(deepcopy(subs))
    subs_history[-1]['previous_sim_name'] = subs['filebase']
    
    return subs


def main():
    temperature = named_parameter('t', 25.0)
    um = named_parameter('um', -13.0*10.0**(-3.0))
    phase = named_parameter('phase', 'i')
    radius = named_parameter('radius', 20)
    thickness = named_parameter('thickness', '20')
    needprev = named_parameter('needprev', False)
    dpot = named_parameter('dpot', np.linspace(0.0, 1.0, 10))

    ischeme_elements = Constants(temperature, phase, radius, thickness, um, needprev) \
                       >> ISE(dpot)
    ischeme = namedtuple_adapter(IS(ischeme_elements))

    subs_history = []
    compute_substitutions = partial(_compute_substitutions, subs_history)

    for values in ischeme:
        subs = compute_substitutions(values)
        sim_config = prepare_config('./sim.i')
        new_config = sim_config(subs)

        sim_filename = f"{subs['filebase']}.i"
        with open(sim_filename, 'w') as simfile:
            simfile.writelines(new_config)

        ferret_run = f'mpiexec -n 8 ferret-opt -i {sim_filename}'
        procresult = run(ferret_run, shell=True)
        if procresult.returncode != 0:
            exit(1)


if __name__ == '__main__':
    main()
