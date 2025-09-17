%% Fig5  
% refer https://doi.org/10.1038/s41593-022-01082-w
%% ROI or network
%% load
[patt, patt_names] = load_SR_maps_thr;
patt.image_names = patt_names';
load('defensive_system_atlas.mat');  %load_image_set('bucknerlab')for network
defen_atlas.image_names = atlas_obj.labels;

% Colors
n = length(patt_names);
patt_colors={[131/255 157/255 220/255] [122/255 112/255 181/255] [241/255 118/255 109/255] [252/255 187/255 62/255]}; 
defen_colors = {[255/255 119/255 119/255] [255/255 119/255 119/255] [255/255 191/255 97/255] [119/255 205/255 255/255] [119/255 205/255 255/255] [119/255 205/255 255/255] };
           
clear sim_matrix
figure;

[layer1, layer2, ribbons, sim_matrix] = riverplot(patt, 'layer2', atlas_obj, 'layer1colors', patt_colors, 'layer2colors', defen_colors');
%riverplot_toggle_lines(ribbons);

% Mini Pies
cols=[131/255 157/255 220/255
      122/255 112/255 181/255
      241/255 118/255 109/255
      252/255 187/255 62/255];

piedata=abs(sim_matrix) 
piedata(piedata==0) = 0.00001

figtitle=sprintf('Mini_pies.png');
create_figure(figtitle)
for i = 1:size(piedata,1)
    subplot(1,size(piedata,1),i)
    h = wani_pie(piedata(i,:)./sum(piedata(i,:))*100, 'cols',cols, 'notext');
end

