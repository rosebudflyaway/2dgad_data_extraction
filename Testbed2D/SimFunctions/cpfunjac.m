function [f,J,domerr] = cpfunjac(z, jacflag)

    global m_row1Index m_row2Index m_row3Index m_row4Index
    global m_row5Index m_row6Index m_row7Index dimension;
    global m_stepSize sMu;
    global globalMass;
    global supportForces;
    global Wn Wf Wt_s Wo_s E U;
    global b;
    
    z1 = z(m_row1Index:m_row2Index-1);
    z2 = z(m_row2Index:m_row3Index-1);
    z3 = z(m_row3Index:m_row4Index-1);
    z4 = z(m_row4Index:m_row5Index-1);
    z5 = z(m_row5Index:m_row6Index-1);
    z6 = z(m_row6Index:m_row7Index-1);
    z7 = z(m_row7Index:dimension);

    f = zeros(dimension, 1);
    J = zeros(dimension, dimension);

   %% Calculate the function value

    % Evaluate the function value as f
    f(m_row1Index:m_row2Index-1) = b(m_row1Index:m_row2Index-1) - globalMass*z1 + Wn*z2 + Wf*z3 + Wt_s*z4 + Wo_s*z5;
    f(m_row2Index:m_row3Index-1) = b(m_row2Index:m_row3Index-1) + Wn'*z1;
    f(m_row3Index:m_row4Index-1) = b(m_row3Index:m_row4Index-1) + Wf'*z1 + E*z6;
    
    % The sixth and seventh row are special
    temp = sMu * supportForces * m_stepSize;
    f(m_row4Index:m_row5Index-1) = temp.*(Wt_s'*z1) + z4.*z7;
    f(m_row5Index:m_row6Index-1) = temp.*(Wo_s'*z1) + z5.*z7;
    f(m_row6Index:m_row7Index-1) = U*z2 - E'*z3;
    f(m_row7Index:dimension)     = b(m_row7Index:dimension) - 0.5*(z4.*z4) - 0.5*(z5.*z5);
   %% Evaluate the jacobian matrix

    % the first big column
    J(m_row1Index:m_row2Index-1, m_row1Index:m_row2Index-1) = -globalMass;
    J(m_row2Index:m_row3Index-1, m_row1Index:m_row2Index-1) = Wn';
    J(m_row3Index:m_row4Index-1, m_row1Index:m_row2Index-1) = Wf';
    J(m_row4Index:m_row5Index-1, m_row1Index:m_row2Index-1) = diag(temp) * Wt_s';
    J(m_row5Index:m_row6Index-1, m_row1Index:m_row2Index-1) = diag(temp) * Wo_s';

    % the second big column
    J(m_row1Index:m_row2Index-1, m_row2Index:m_row3Index-1) = Wn;
    J(m_row6Index:m_row7Index-1, m_row2Index:m_row3Index-1) = U;

    % the third big column
    J(m_row1Index:m_row2Index-1, m_row3Index:m_row4Index-1) = Wf;
    J(m_row6Index:m_row7Index-1, m_row3Index:m_row4Index-1) = -E';

    % the fourth big column
    J(m_row1Index:m_row2Index-1, m_row4Index:m_row5Index-1) = Wt_s;
    J(m_row4Index:m_row5Index-1, m_row4Index:m_row5Index-1) = diag(z7);
    J(m_row7Index:dimension,     m_row4Index:m_row5Index-1) = -diag(z4);

    % the fifth big column
    J(m_row1Index:m_row2Index-1, m_row5Index:m_row6Index-1) = Wo_s;
    J(m_row5Index:m_row6Index-1, m_row5Index:m_row6Index-1) = diag(z7);
    J(m_row7Index:dimension,     m_row5Index:m_row6Index-1) = -diag(z5);

    % the sixth big column
    J(m_row3Index:m_row4Index-1, m_row6Index:m_row7Index-1) = E;

    % the seventh big column
    J(m_row4Index:m_row5Index-1, m_row7Index:dimension) = diag(z4);
    J(m_row5Index:m_row6Index-1, m_row7Index:dimension) = diag(z5);

    % Sparse if needed
    if jacflag
       J = sparse(J); 
    end
    
    domerr = 0;
    
end