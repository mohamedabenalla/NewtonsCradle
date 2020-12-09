function untitled2
    % Pendulum Simulation
    % 
    % 
    figure
     %  Create and then hide the UI as it is being constructed.
    f = figure('Visible','off','Position',[360,500,450,325]);
    hstart    = uicontrol('Style','pushbutton',...
             'String','Start','Position',[315,250,70,25],...
             'Callback',@startbutton_Callback);
    %fig = uifigure;
    htextx1  = uicontrol('Style','text','String','Initial Position 1',...
           'Position',[300,225,100,15]);
    hx1 = uicontrol('Style', 'slider',...
       'Position',[300,210,100,15], 'Callback',@x1_Callback);
    htextv1  = uicontrol('Style','text','String','Initial Velocity 1',...
           'Position',[300,190,100,15]);
    hv1 = uicontrol('Style', 'slider', 'Value',0,...
       'Position',[300,175,100,15], 'Callback',@v1_Callback);
    htextx2  = uicontrol('Style','text','String','Initial Position 2',...
           'Position',[300,155,100,15]);
    hx2 = uicontrol('Style', 'slider',...
       'Position',[300,140,100,15], 'Callback',@x2_Callback);
    htextv2  = uicontrol('Style','text','String','Initial Velocity 2',...
           'Position',[300,120,100,15]);
    hv2 = uicontrol('Style', 'slider',...
       'Position',[300,105,100,15], 'Callback',@v2_Callback);
    htext  = uicontrol('Style','text','String','Select Collison',...
           'Position',[300,75,100,15]);
    hpopup = uicontrol('Style','popupmenu',...
           'String',{'Perfectly Elastic','Elastic','Inelastic', 'Perfectly Inelastic'},...
           'Position',[300,50,100,25], 'Callback',@popup_menu_Callback);
    
    elastic = 1; %elastic coeffecient
    x1_initial = pi/3;
    v1_initial = 0;
    x2_initial = -pi/4;
    v2_initial = 0;
    ha = axes('Units','pixels','Position',[50,60,200,185]);
    % off means disappearing
    % distance from left, distance from bottom, width, height
    align([hstart,htext,hpopup,hx1,hv1,hx2,hv2],'Center','None');
    
    % Initialize the UI.
% Change units to normalized so components resize automatically.
    f.Units = 'normalized';
    ha.Units = 'normalized';
    hstart.Units = 'normalized';
    htext.Units = 'normalized';
    hpopup.Units = 'normalized';
    hx1.Units  = 'normalized';
    hv1.Units  = 'normalized';
    hx2.Units  = 'normalized';
    hv2.Units  = 'normalized';
    % Assign the a name to appear in the window title.
    f.Name = 'Newtons Cradle';

    % Move the window to the center of the screen.
    movegui(f,'center')

    % Make the window visible.
    f.Visible = 'on';
%  Pop-up menu callback. Read the pop-up menu Value property to
%  determine which item is currently displayed and make it the
%  current data. This callback automatically has access to 
%  current_data because this function is nested at a lower level.
function popup_menu_Callback(source,eventdata) 
      % Determine the selected data set.
      str = source.String;
      val = source.Value;
      % Set current data to the selected data set.
      switch str{val};
        case 'Perfectly Elastic' 
         elastic = 1;
        case 'Elastic' 
         elastic = 0.7;
        case 'Inelastic' 
         elastic = 0.5;
        case 'Perfectly Inelastic' 
         elastic = 0;
      end
end

 % Push button callbacks. Each callback plots current_data in the
  % specified plot type.
function x1_Callback(source,eventdata) 
      % Determine the selected data set.
       x1_initial = app.Slider.Value;
end
function v1_Callback(source,eventdata) 
      % Determine the selected data set.
      x2_initial = app.Slider.Value;
end
function x2_Callback(source,eventdata) 
      % Determine the selected data set.
      x1_initial = app.Slider.Value;
end
function v2_Callback(source,eventdata) 
      % Determine the selected data set.
      x1_initial = app.Slider.Value;
end
  function startbutton_Callback(source,eventdata) 
  % Display surf plot of the currently selected data.

        hold on;
        blue = [0 0.4470 0.7410];
        cyan = [0.4660 0.6740 0.1880];
        hp1 = plot(0,0,'.blue', 'MarkerSize', 20);
        hp2 = plot(0,0,'.cyan', 'MarkerSize', 20);
        hl1 = plot(0,0,'blue');
        hl2 = plot(0,0,'cyan');

        axis equal;
        xlim([-1 1]);
        ylim([-1 0.1]);
        r = 0.02; % radius
        l = 0.6; % length
        m1 = 1; %mass1
        m2 = 0.5;  %mass2

        p1_offset = [r; 0];
        p2_offset = [-r; 0];

        ts = 0.005;
        timespan = 0:ts:5;

        g = 9.81;

        x1 = x1_initial;
        v1 = v1_initial;
        x2 = x2_initial;
        v2 = v2_initial;
        
        indicatorValue = 0;
        for k = 1 : length(timespan)
            a1 = -(g*sin(x1));
            v1 = v1 + a1 * ts;            
            x1 = x1 + (v1/l) * ts;
    
            a2 = -(g*sin(x2));                                                                                                                                            
            v2 = v2 + a2 * ts;
            x2 = x2 + (v2/l) * ts;
    
            p1 = [l*sin(x1); -l*cos(x1)] + p1_offset;
            p2 = [l*sin(x2); -l*cos(x2)] + p2_offset;
    
            if norm(p1-p2) < 2*r
                if indicatorValue == 0
                    v3 = v1;
                    v1 = v2 * elastic * m1 / m2 ;
                    v2 = v3 * elastic * m2 / m1;
                    indicatorValue = 1;
                end
            else
                indicatorValue = 0;
            end

    
            set(hp1, 'XData', p1(1), 'YData', p1(2));
            set(hp2, 'XData', p2(1), 'YData', p2(2));
            set(hl1, 'XData', [p1_offset(1) p1(1)], 'YData', [p1_offset(2) p1(2)]);
            set(hl2, 'XData', [p2_offset(1) p2(1)], 'YData', [p2_offset(2) p2(2)]);
    
            drawnow;
        end
        voidValue = -100 %Just allows me to clear the plot
        set(hp1, 'XData', voidValue, 'YData', voidValue);
        set(hp2, 'XData', voidValue, 'YData', voidValue);
        set(hl1, 'XData', [voidValue voidValue], 'YData', [voidValue voidValue]);
        set(hl2, 'XData', [voidValue voidValue], 'YData', [voidValue voidValue]);
  end
end
