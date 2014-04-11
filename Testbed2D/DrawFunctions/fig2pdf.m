 % Given a string name, saves the current figure to [name].pdf

function fig2pdf ( name )

    set(gcf, 'PaperPosition', [0.0 -0.0 6 5.3]); 
    set(gcf, 'PaperSize', [5.6 5.6]);               
    saveas(gcf, name, 'pdf'); 
    
end