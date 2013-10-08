function [SolutionTimes SolutionDists SolutionConc] = PBESolver (PD)

% PBESOLVER
%
% Solve PBEs, like a boss

solvefun = str2func(PD.sol_method);
solvefun = @(t,X) solvefun(t,X,PD);

switch PD.sol_method

    case 'movingpivot'
        dL = 5; % critical bin size for event listener
        X0 = [PD.init_dist.F.*diff(PD.init_dist.boundaries) ...
            PD.init_dist.y PD.init_dist.boundaries PD.init_conc];
        tstart = PD.sol_time(1); % local start time
        tend = PD.sol_time(end); % overall end time

        % if nucleation is present, bins are addded when the first bin
        % becomes too big
        options = PD.ODEoptions;
        options = odeset(options,'Events',@(t,x) EventAddBin(t,x,dL));
        
        SolutionTimes = []; SolutionConc = [];
        s=0;
        while tstart<tend 
            ts = PD.sol_time(PD.sol_time > tstart & PD.sol_time < tend);
            if tstart ~= PD.sol_time(1)
                X0 = addBin(X_out(end,:)'); 
%                 keyboard
            end
            % Solve until the next event where the nucleation bin becomes to big (as defined by dL)
            [T,X_out] = ode15s(solvefun, [tstart ts tend],X0, options);
            
            nBins = (size(X_out,2)-2)/3;            
            F = X_out(:,1:nBins)./diff(X_out(:,2*nBins+1:3*nBins+1),1,2); F(isnan(F)) = 0;
            
            SolutionTimes = [SolutionTimes;T(:)];
            SolutionConc = [SolutionConc;X_out(:,end)];
            for i = 1:length(T)
                SolutionDists(s+i) = Distribution( X_out(i,nBins+1:2*nBins),...
                    F(i,:),...
                    X_out(i,2*nBins+1:3*nBins+1) );
            end
            s = s+length(T);
            tstart = T(end); 
            
        end %while        
        
    case 'centraldifference'
        X0 = [PD.init_dist.F, PD.init_conc];
        
        [SolutionTimes,X_out] = ode15s(solvefun , PD.sol_time , X0 ,PD.ODEoptions);

    case 'hires'
        
        [SolutionTimes,X_out] = hires(PD);
         
end %switch

if ~strcmpi(PD.sol_method,'movingpivot')
    SolutionConc = X_out(:,end);
    SolutionDists = repmat(Distribution(),1,length(SolutionTimes));  %# Pre-Allocation for speed               
    for i = 1:length(SolutionTimes)
            SolutionDists(i) = Distribution( PD.init_dist.y, X_out(i,1:length(PD.init_dist.y)),PD.init_dist.boundaries );
    end % for
end

end % function