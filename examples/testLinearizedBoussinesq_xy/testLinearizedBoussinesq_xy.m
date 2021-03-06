clear all

p.home = '/Users/glwagner/Numerics/mat2Periodic';
p.physics = 'linearizedBoussinesq_xy';
p.name = 'testLinearizedBoussinesq_xy';

p.nx = 256;
p.Lx = 1e6;
p.nSteps = 1e3;

% Physical parameters: inertial freq, kappa, viscosity
p.f0 = 1e-4;
% Constant N kappa = N*pi/f*H
p.kappa = 2e-3*pi / (p.f0*4e3);
p.nu = 1e8;
p.nuN = 4;

p.dt = 1e-2 * (2*pi/p.f0);

% Step-interval between display.
p.dnPrint = 1e2;
p.dnPlot = p.dnPrint;
p.dnSave = 1e2;

%p.timeStepper = 'RK4';
p.timeStepper = 'ETDRK4';

% Square domain
p.ny = p.nx;
p.Ly = p.Lx;

% Manage code in the sadly-MATLABian-necessary way.
codeDir = sprintf('%s/code', pwd);
sourceDir = sprintf('%s/source', p.home);
physicsDir = sprintf('%s/physics/%s', p.home, p.physics);

if ~exist(codeDir), mkdir(codeDir)
else eval(sprintf('!rm %s/*', codeDir))
end

% Copy code and mat-files into code directory
eval(sprintf('!cp %s/*.m %s/', sourceDir, codeDir)) 
eval(sprintf('!cp %s/*.m %s/', physicsDir, codeDir)) 
eval(sprintf('!cp %s/*.m* %s/', pwd, codeDir)) 

% Initialize and run the model
[p, sol] = initializeModel(p);
[p, sol] = runSpectralModel(p, sol, p.nSteps);

% Plot solution at the end.
quickPlot(p, sol);
