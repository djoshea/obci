function summarizeConditions(C, conditionRepeats)
     totalReps = sum([conditionRepeats]);
%      fracChannel = sum(conditionRepeats([C.hasChannel] > 0)) / totalReps;
%      fracPerturb = sum(conditionRepeats([C.perturb] > 0)) / totalReps;
%      fracChannelPerturb = sum(conditionRepeats([C.perturb] > 0 & [C.hasChannel] > 0)) / totalReps;

     fprintf('%d total condition repeats\n', totalReps);
%      fprintf('%.1f %% channel\n', fracChannel*100);
%      fprintf('%.1f %% perturbation, %.1f %% channel perturbation\n', fracPerturb*100, fracChannelPerturb*100);
     
   %% plot layouts
    figure(5);
    clf, set(gcf, 'Color', 'w');
    set(gcf, 'Position', [969 9 944 1108], 'NumberTitle', 'off', 'Name', 'ChannelReach Condition Summary');
    nRows = 1;
    drawPoly = @(ptsX, ptsY, color) fill(ptsX([1:end 1]), ptsY([1:end 1]), color, 'EdgeColor', 'none');
    cidx = 1;        
    xOffset = 0;
    yOffset = 0;
    row = 0;
    colorChannel = [1 0.5 0.5];

    for iC = 1:numel(C)
        c = C(iC);
        
        % draw all targets
        fillCircle(c.targetX + xOffset, c.targetY + yOffset, c.targetSize, 'g', 'k');
%         fill(c.targetPointsDisplayX + xOffset, c.targetPointsDisplayY + yOffset, ...
%             '-', 'EdgeColor', [0.5 0.5 0.5], 'FaceColor', [0.5 0.5 0.5]);
        hold on
%         idx = c.targetIndexPostShift;
%         fill(c.targetPointsDisplayX(:, idx) + xOffset, c.targetPointsDisplayY(:, idx) + yOffset, ...
%             '-', 'EdgeColor', [0.5 1 0.5], 'FaceColor', [0.5 1 0.5]);
%         
%         % edge haptic targets
%         plot(c.targetPointsHapticX + xOffset, c.targetPointsHapticY + yOffset, ...
%             '-', 'LineWidth', 1, 'Color', [0.2 0.2 0.2]);
%         
%         % lateral deviation constraints
%         plot(c.lateralConstraintsHapticX + xOffset, c.lateralConstraintsHapticY + yOffset, ...
%             '-', 'LineWidth', 1, 'Color', [0.8 0.2 0.2]);
%         
        % center +
        plot(c.centerX + xOffset, c.centerY + yOffset, '+', ...
            'MarkerSize', 8, 'MarkerEdgeColor', [0.5 0.5 0.5]);
        


        label = sprintf('%s\nC%d', char(c.conditionDesc), iC);
       
        label = [label ' x ' num2str(conditionRepeats(iC))]; %#ok<AGROW>
        text(xOffset, yOffset-180, label, 'HorizontalAlign', 'Center', 'FontSize', 7)
        
        cidx = cidx + 1;
        
        if row == nRows - 1
            yOffset = 0;
            xOffset = xOffset + 500;
            row = 0;
        else
            row = row + 1;
            yOffset = yOffset - 400;
        end  
    end
    
    axis equal
    axis tight
    axis off
    set(gca, 'LooseInset', [0.1 0 0.1 0]);

end

function h = fillCircle(xc, yc, rad, fill, edge)
    t = linspace(0, 2*pi, 100);
    x = cos(t)*rad + xc;
    y = sin(t)*rad + yc;
    h = patch(x, y, fill, 'EdgeColor', edge, 'FaceAlpha', 0.7);
end
