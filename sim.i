[Mesh]
  type = FileMesh
  file = {subs:mesh_name}
[]

[Variables]
  [./polar_x]
    order = FIRST
    family = LAGRANGE
    block = 'dot'
  [../]
  [./polar_y]
    order = FIRST
    family = LAGRANGE
    block = 'dot'
  [../]
  [./polar_z]
    order = FIRST
    family = LAGRANGE
    block = 'dot'
  [../]

  [./potential]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[ICs]
  active = {subs:active_ics}
  
  #RANDOM CONDITIONS FOR FIRST ITERATION
  [./ic_polar_x_ferro_random]
    type = RandomIC
    min = {subs:polar_x_value_min}
    max = {subs:polar_x_value_max}
    variable = polar_x
  [../]
  [./ic_polar_y_ferro_random]
    type = RandomIC
    min = {subs:polar_y_value_min}
    max = {subs:polar_y_value_max}
    variable = polar_y
  [../]
  [./ic_polar_z_ferro_random]
    type = RandomIC
    min = {subs:polar_z_value_min}
    max = {subs:polar_z_value_max}
    variable = polar_z
  [../]
 
  [./pxic]
      type = FunctionIC
      variable = polar_x
      function = pxf
  [../]
  [./pyic]
    type = FunctionIC
    variable = polar_y
    function = pyf
  [../]
  [./pzic]
    type = FunctionIC
    variable = polar_z
    function = pzf
  [../]
  [./potic]
    type = FunctionIC
    variable = potential
    function = potf
  [../]

[]

[Functions]
  active = {subs:active_funcs}
  
  [./pxf]
    type = SolutionFunction
    solution = soln
    from_variable = polar_x
  [../]
  [./pyf]
    type = SolutionFunction
    solution = soln
    from_variable = polar_y
  [../]
  [./pzf]
    type = SolutionFunction
    solution = soln
    from_variable = polar_z
  [../]
  [./potf]
    type = SolutionFunction
    solution = soln
    from_variable = potential
  [../]

[]

[Kernels]
  #FERROELECTRIC BLOCK
  [./bed_x_ferro]
    type = BulkEnergyDerivativeSixth
    variable = polar_x
    polar_x = polar_x
    polar_y = polar_y
    polar_z = polar_z
    alpha1 = {subs:alpha1}
    alpha11 = {subs:alpha11}
    alpha12 = {subs:alpha12}
    alpha111 = {subs:alpha111}
    alpha112 = {subs:alpha112}
    alpha123 = {subs:alpha123}
    component = 0
    block = 'dot'
  [../]
  [./bed_y_ferro]
    type = BulkEnergyDerivativeSixth
    variable = polar_y
    polar_x = polar_x
    polar_y = polar_y
    polar_z = polar_z
    alpha1 = {subs:alpha1}
    alpha11 = {subs:alpha11}
    alpha12 = {subs:alpha12}
    alpha111 = {subs:alpha111}
    alpha112 = {subs:alpha112}
    alpha123 = {subs:alpha123}
    component = 1
    block = 'dot'
  [../]
  [./bed_z_ferro]
    type = BulkEnergyDerivativeSixth
    variable = polar_z
    polar_x = polar_x
    polar_y = polar_y
    polar_z = polar_z
    alpha1 = {subs:alpha1}
    alpha11 = {subs:alpha11}
    alpha12 = {subs:alpha12}
    alpha111 = {subs:alpha111}
    alpha112 = {subs:alpha112}
    alpha123 = {subs:alpha123}
    component = 2
    block = 'dot'
  [../]

  [./walled_x_ferro]
    type = WallEnergyDerivative
    variable = polar_x
    polar_x = polar_x
    polar_y = polar_y
    polar_z = polar_z
    len_scale = {subs:lscale}
    G110 = {subs:G110}
    G11_G110 = {subs:G11_G110}
    G12_G110 = {subs:G12_G110}
    G44_G110 = {subs:G44_G110}
    G44P_G110 = {subs:G44P_G110}
    component = 0
    block = 'dot'
  [../]
  [./walled_y_ferro]
    type = WallEnergyDerivative
    variable = polar_y
    polar_x = polar_x
    polar_y = polar_y
    polar_z = polar_z
    len_scale = {subs:lscale}
    G110 = {subs:G110}
    G11_G110 = {subs:G11_G110}
    G12_G110 = {subs:G12_G110}
    G44_G110 = {subs:G44_G110}
    G44P_G110 = {subs:G44P_G110}
    component = 1
    block = 'dot'
  [../]
  [./walled_z_ferro]
    type = WallEnergyDerivative
    variable = polar_z
    polar_x = polar_x
    polar_y = polar_y
    polar_z = polar_z
    len_scale = {subs:lscale}
    G110 = {subs:G110}
    G11_G110 = {subs:G11_G110}
    G12_G110 = {subs:G12_G110}
    G44_G110 = {subs:G44_G110}
    G44P_G110 = {subs:G44P_G110}
    component = 2
    block = 'dot'
  [../]

  [./polar_x_time_ferro]
     type = TimeDerivativeScaled
     variable = polar_x
     time_scale = {subs:time_scale}
     block = 'dot'
  [../]
  [./polar_y_time_ferro]
     type = TimeDerivativeScaled
     variable = polar_y
     time_scale = {subs:time_scale}
     block = 'dot'
  [../]
  [./polar_z_time_ferro]
     type = TimeDerivativeScaled
     variable = polar_z
     time_scale = {subs:time_scale}
     block = 'dot'
  [../]
  
  [./polar_x_electric_E_ferro]
     type = PolarElectricEStrong
       block = 'dot'
       polar_x = polar_x
       polar_y = polar_y
       polar_z = polar_z
       len_scale = {subs:lscale}
       variable = potential
  [../]
  [./FE_E_int_ferro]
       type = Electrostatics
       block = 'dot'
       variable = potential
       permittivity = {subs:permittivity_electrostatic_ferro}
       len_scale = {subs:lscale}
  [../]

  [./polar_electric_px_ferro]
     type = PolarElectricPStrong
       block = 'dot'
       variable = polar_x
       len_scale = {subs:lscale}
       potential_E_int = potential
       component = 0
  [../]
  [./polar_electric_py_ferro]
     type = PolarElectricPStrong
       block = 'dot'
       variable = polar_y
       len_scale = {subs:lscale}
       potential_E_int = potential
       component = 1
  [../]
  [./polar_electric_pz_ferro]
     type = PolarElectricPStrong
       block = 'dot'
       variable = polar_z
       len_scale = {subs:lscale}
       potential_E_int = potential
       component = 2
  [../]

  [./medium_electrostatics]
       type = Electrostatics
       block =  'medium'
       variable = potential
       permittivity = {subs:permittivity_electrostatic_para}
       len_scale = {subs:lscale}
  [../]
  
[]

[BCs]
   [./top_phi]
      type = DirichletBC
      variable = potential
      value = {subs:up_pot}
      boundary = 'medium_top'
   [../]
   [./bottom_phi]
      type = DirichletBC
      variable = potential
      value = {subs:bottom_pot}
      boundary = 'shared_bottom'
   [../] 
[]

[Postprocessors]
   [./dt]
     type = TimestepSize
   [../]
  
  [./Fbulk]
      type = BulkEnergy
      polar_x = polar_x
      polar_y = polar_y
      polar_z = polar_z
      alpha1 = {subs:alpha1}
      alpha11 = {subs:alpha11}
      alpha12 = {subs:alpha12}
      alpha111 = {subs:alpha111}
      alpha112 = {subs:alpha112}
      alpha123 = {subs:alpha123}
      execute_on = 'initial timestep_end final'
      block = 'dot'
   [../]
   [./Fwall]
      type = WallEnergy
      polar_x = polar_x
      polar_y = polar_y
      polar_z = polar_z
      G110 = {subs:G110}
      G11_G110 = {subs:G11_G110}
      G12_G110 = {subs:G12_G110}
      G44_G110 = {subs:G44_G110}
      G44P_G110 = {subs:G44P_G110}
      len_scale = {subs:lscale}
      execute_on = 'initial timestep_end final'
      block = 'dot'
    [../]
    [./Fdepol]
      type = DepolarizationEnergy
      permitivitty = {subs:permitivitty_depol_ferro}
      lambda = {subs:lmbd}
      len_scale = {subs:lscale}
      avePz = Polar_z_ferro_avg_element
      polar_z = polar_z
      execute_on = 'initial timestep_end final'
      block = 'dot'
    [../]
    [./Felec]
      type = ElectrostaticEnergy
      block = 'dot'
      polar_x = polar_x
      polar_y = polar_y
      polar_z = polar_z
      potential_E_int = potential
      len_scale = {subs:lscale}
      execute_on = 'initial timestep_end final'
    [../]

    [./Ftotal]
      type = LinearCombinationPostprocessor
      pp_names = 'Fbulk Fwall Fdepol Felec'
      pp_coefs = '   1     1     1     1  '
      execute_on = 'initial timestep_end final'
    [../]
    [./perc_change]
     type = EnergyRatePostprocessor
     postprocessor = Ftotal
     dt = dt 
     execute_on = 'initial timestep_end final'
    [../]
   
   [./Polar_z_ferro_avg_element]
    type = ElementAverageValue
    execute_on = 'initial timestep_end final'
    variable = polar_z
    block = 'dot'
   [../]

[]

[UserObjects]
  active = {subs:active_user_objects}

  [./soln]
    type = SolutionUserObject
    mesh = {subs:previous_sim}
    system_variables = 'polar_x polar_y polar_z potential'
    timestep = LATEST
    execute_on = initial
 [../]
  
  [./kill]
    type = Terminator
    expression = 'perc_change <= 1.0e-6'
  [../]

[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
    petsc_options_iname = ' -pc_type '     
    petsc_options_value = '  bjacobi '    
  [../]
[]

[Executioner]

  [./TimeStepper]
     type = IterationAdaptiveDT
     dt = 0.01
     growth_factor = 1.414
     cutback_factor =  0.707
  [../]

  type = Transient
  solve_type = 'NEWTON' 
  scheme = 'bdf2' 
  
  dtmax = 0.7
[]

[Outputs]
  print_linear_residuals = false
  print_perf_log = false
  
  [./out]
    type = Exodus
    execute_on = 'final'
    file_base = {subs:filebase}
    elemental_as_nodal = true
  [../]
  
[]
