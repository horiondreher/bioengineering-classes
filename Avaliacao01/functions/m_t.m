function [m_t] = m_t(t, m, a_m, b_m)

    m_t = a_m*(1-m) - b_m*m;

end

