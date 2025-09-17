import imgkit  
import os
import pandas as pd  
import numpy as np  
from pyecharts.charts import Pie  
from pyecharts.charts import Polar
from pyecharts.charts import Bar
from pyecharts.faker import Faker
from pyecharts import options as opts


data = pd.read_excel(r'fsw_rose.xlsx')

regions = data['region'].values.tolist()
coverage = data['coverage'].values.tolist() 
attributes = data['attribute'].values.tolist()

region_coverage_attr = list(zip(regions, coverage, attributes))
#sorted_region_coverage_attr = sorted(region_coverage_attr, key=lambda x: x[1])
sorted_region_coverage_attr = sorted(region_coverage_attr, key=lambda x: x[1], reverse=True)  

sorted_regions, sorted_coverage, sorted_attributes = zip(*sorted_region_coverage_attr)
print (sorted_regions, sorted_coverage, sorted_attributes)

 
 
def generate_color_gradient(base_color, count):   
    colors = []  
    for i in range(count):  
        color = f'rgba({base_color[0]}, {base_color[1]}, {base_color[2]}, {1 - (i / count):.2f})'  
        colors.append(color)  
    return colors  

positive_gradients = generate_color_gradient((255, 68, 72), sum(1 for attr in sorted_attributes if attr == 'positive'))
negative_gradients = generate_color_gradient((66, 146, 255), sum(1 for attr in sorted_attributes if attr == 'negative'))   

color_series = []  
for attr in sorted_attributes:
    if attr == 'positive':  
        color_series.append(positive_gradients.pop(0))   
    else:  # negative  
        color_series.append(negative_gradients.pop(0)) 

print (color_series)



rosechart = Pie(init_opts=opts.InitOpts(width='1200px', height='800px'))
rosechart.set_colors(color_series)  

rosechart.add("", 
              [list(z) for z in zip(sorted_regions, sorted_coverage)],  
              radius=["20%", "80%"],  
              center=["50%", "50%"],  
              rosetype="area", 
              label_line_opts = False) 
              
output_file = r'fsw_rosechart.html'
rosechart.render(output_file)  






