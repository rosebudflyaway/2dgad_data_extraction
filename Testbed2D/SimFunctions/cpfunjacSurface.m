function [f,J,domerr] = cpfunjacSurface(z, jacflag)

    global m_row1Index m_row2Index m_row3Index m_row4Index
    global dimension;
    global m_stepSize sMu;
    global globalMass Nu;
    global supportForces globalPext;
    global Wt_s Wo_s;
    global vNoise
    
    z1 = z(m_row1Index:m_row2Index-1);
    z2 = z(m_row2Index:m_row3Index-1);
    z3 = z(m_row3Index:m_row4Index-1);
    z4 = z(m_row4Index:dimension);

    f = zeros(dimension, 1);
    J = zeros(dimension, dimension);

   %% Calculate the function value

    % first creat the vector b
    b = zeros(dimension, 1);
    b(m_row1Index:m_row2Index-1) = globalMass * Nu(:) + globalPext;
    b(m_row4Index:dimension)     = sMu*sMu*m_stepSize*m_stepSize*0.5*(supportForces.*supportForces);
    
    % Evaluate the function value as f
    f(m_row1Index:m_row2Index-1) = b(m_row1Index:m_row2Index-1) - globalMass*z1 + Wt_s*z2 + Wo_s*z3;
    temp = sMu * supportForces * m_stepSize;
    f(m_row2Index:m_row3Index-1) = temp.*(Wt_s'*z1) + z2.*z4;
    f(m_row3Index:m_row4Index-1) = temp.*(Wo_s'*z1) + z3.*z4;
    f(m_row4Index:dimension)     = b(m_row4Index:dimension) - 0.5*(z2.*z2) - 0.5*(z3.*z3);
   %% Evaluate the jacobian matrix
   
    % the first big column
    J(m_row1Index:m_row2Index-1, m_row1Index:m_row2Index-1) = -globalMass;
    J(m_row2Index:m_row3Index-1, m_row1Index:m_row2Index-1) = diag(temp) * Wt_s';
    J(m_row3Index:m_row4Index-1, m_row1Index:m_row2Index-1) = diag(temp) * Wo_s';

    % the second big column
    J(m_row1Index:m_row2Index-1, m_row2Index:m_row3Index-1) = Wt_s;
    J(m_row2Index:m_row3Index-1, m_row2Index:m_row3Index-1) = diag(z4);
    J(m_row4Index:dimension,     m_row2Index:m_row3Index-1) = -diag(z2);

    % the third big column
    J(m_row1Index:m_row2Index-1, m_row3Index:m_row4Index-1) = Wo_s;
    J(m_row3Index:m_row4Index-1, m_row3Index:m_row4Index-1) = diag(z4);
    J(m_row4Index:dimension,     m_row3Index:m_row4Index-1) = -diag(z3);

    % the fourth big column
    J(m_row2Index:m_row3Index-1, m_row4Index:dimension) = diag(z2);
    J(m_row3Index:m_row4Index-1, m_row4Index:dimension) = diag(z3);

    % Sparse if needed
    if jacflag
       J = sparse(J); 
    end
    
    domerr = 0;
end