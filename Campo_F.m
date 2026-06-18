%% Parámetros físicos
a = 5.0;       % espesor del cable partido de 2 (a >> lambda)
lambda = 1.0;  % longitud de penetración
F0 = 1.0;      % campo aplicado en la superficie

%% Solución analítica
x = linspace(-a, a, 400);
F = F0*cosh(x/lambda)./cosh(a/lambda);

%% Figura
fig = figure('Color','w','Position',[100 100 1300 520]);

%% Figura izquierda: campo vectorial con flechas
subplot(1,2,1)
hold on;
box on;

% Rectángulo del cable (fondo claro)
fill([-a -a a a], [-1 1 1 -1], [0.95 0.95 1], 'EdgeColor','none');

% Posiciones de las flechas
x_arrows = linspace(-a*0.95, a*0.95, 25);
y_positions = linspace(-0.7, 0.7, 5);

color_arrow = [0.75 0.1 0.1];

for yi = 1:length(y_positions)
    y_arr = y_positions(yi);
    for xi = 1:length(x_arrows)
        x_arr = x_arrows(xi);
        Fmag = F0*cosh(x_arr/lambda)/cosh(a/lambda);
        arrow_len = 0.6*Fmag;
        if arrow_len > 0.02
            quiver(x_arr - arrow_len/2, y_arr, arrow_len, 0, 0, ...
                   'Color', color_arrow, 'LineWidth', 1.6, ...
                   'MaxHeadSize', 1.5, 'AutoScale','off');
        end
    end
end

% Superficies del cable
plot([-a -a],[-1 1],'k-','LineWidth',2.5)
plot([a a],[-1 1],'k-','LineWidth',2.5)

% Marcas de lambda desde cada superficie
plot([-a+lambda -a+lambda],[-1 1],'--','Color',[0 0.5 0],'LineWidth',1.5)
plot([a-lambda a-lambda],[-1 1],'--','LineWidth',1.5,'Color',[0 0.5 0])

% Etiquetas
text(-a, 1.15, '$x=-a$','Interpreter','latex','FontSize',13,'HorizontalAlignment','center')
text(a, 1.15, '$x=a$','Interpreter','latex','HorizontalAlignment','center','FontSize',13)
text(-a+lambda, -1.2, '$-a+\lambda$','Interpreter','latex','FontSize',12,...
     'Color',[0 0.5 0],'HorizontalAlignment','center')
text(a-lambda, -1.2, '$a-\lambda$','Interpreter','latex','FontSize',12,...
     'HorizontalAlignment','center','Color',[0 0.5 0])

xlim([-a-0.8, a+0.8])
ylim([-1.5 1.5])
title('Penetraci\''on del campo $\mathbf{F}$ en el cable superconductor', ...
      'Interpreter','latex','FontSize',13)
xlabel('$x/\lambda$','Interpreter','latex','FontSize',13)
set(gca,'YTick',[],'FontSize',11,'TickLabelInterpreter','latex')

%% Figura derecha: perfil del campo
subplot(1,2,2)
hold on; box on; grid on;

h_curve = plot(x, F, 'LineWidth', 2.5, 'Color',[0.75 0.1 0.1]);

% Niveles de referencia
yline(1, '--', 'Color',[0.3 0.3 0.3], 'LineWidth', 1)
yline(1/exp(1), ':', 'LineWidth', 1.5, 'Color',[0 0.5 0])

text(-a-0.6, 0.95/exp(1), '$F_0/e$', 'Interpreter','latex','FontSize',12,...
     'Color',[0 0.5 0],'HorizontalAlignment','right','VerticalAlignment','middle')

% Marcas verticales en x = +-(a-lambda)
plot([-a+lambda -a+lambda],[0 1/exp(1)],'--','LineWidth',1.2,'Color',[0 0.5 0])
plot([a-lambda a-lambda],[0 1/exp(1)],'--','Color',[0 0.5 0],'LineWidth',1.2)
plot(-a+lambda, 1/exp(1), 'o', 'MarkerFaceColor',[0 0.5 0],'MarkerEdgeColor','k','MarkerSize',7)
plot(a-lambda, 1/exp(1), 'o', 'MarkerEdgeColor','k','MarkerFaceColor',[0 0.5 0],'MarkerSize',7)

% Indicador de la longitud lambda
y_lambda = 0.15;
plot([a-lambda, a],[y_lambda y_lambda],'-','Color',[0 0.5 0],'LineWidth',1.5)
plot(a-lambda, y_lambda,'>','MarkerFaceColor',[0 0.5 0],'MarkerEdgeColor',[0 0.5 0],'MarkerSize',6)
plot(a, y_lambda,'<','MarkerEdgeColor',[0 0.5 0],'MarkerFaceColor',[0 0.5 0],'MarkerSize',6)
text(a-lambda/2, y_lambda + 0.04, '$\lambda$', 'Interpreter','latex',...
     'FontSize',15, 'Color',[0 0.5 0],'HorizontalAlignment','center','VerticalAlignment','bottom')

xlim([-a-0.5 a+0.5])
ylim([-0.05 1.2])
xlabel('$x/\lambda$','Interpreter','latex','FontSize',13)
ylabel('$F(x)/F_0$','Interpreter','latex','FontSize',13)
title('Perfil del campo dentro del superconductor','Interpreter','latex','FontSize',13)

legend(h_curve, '$F(x)/F_0 = \cosh(x/\lambda)/\cosh(a/\lambda)$', ...
       'Interpreter','latex','Location','north','FontSize',11,'Box','on')

set(gca,'FontSize',11,'TickLabelInterpreter','latex')
