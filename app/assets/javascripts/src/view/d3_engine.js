// Date: 12 October 2016
// JS file to generate the graphical representation in the project via d3js.

define(function() {

  function generateSimpleLineGraph(target, x_axis_values, y_axis_values) {
    let arrData = [];
    for(let count = 0 ; count < x_axis_values.length ; count++ ) {
      arrData.push([x_axis_values[count], y_axis_values[count]]);
    }
     
    let margin = {top: 20, right: 30, bottom: 30, left: 50},
        width = 400 - margin.left - margin.right,
        height = 400 - margin.top - margin.bottom;

    let x = d3.scalePoint()
              .range([0, width - 20]);    

    let y = d3.scaleLinear(); 

    let line = d3.line()
                 .curve(d3.curveBasis)
                 .x(function(d) { return x(d.date); })
                 .y(function(d) { return y(d.close); });   
    
    let area = d3.area()
                 .x(function(d) { return x(d.date); })
                 .y0(300)
                 .y1(function(d) { return y(d.close); });

    let svg = d3.select(target).attr("overflow", "hidden")
                .append("svg")
                .attr("class", "graph-background")
                .attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom)
                .append("g")
                .attr("transform", "translate(" + margin.left + ",30)");    

    let data = arrData.map(function(d) {
      return {
        date: d[0],
        close: d[1]
      };
    });   
    
    let data_count = data.length;
    let object_array = [];
    let counter = 0;
    while(counter < data_count) {
      object_array.push(data[counter].date);
      counter = counter + 1;
    }

    x.domain(object_array);
    y.domain([0, d3.max(data, function(d) { return d.close + 2; })]).range([300, 0]);   

    svg.append("g")
        .attr("class", "x axis label-graph")
        .attr("transform", "translate(0, 300)")
        .call(d3.axisBottom(x));   

    svg.append("g")
        .attr("class", "y axis label-graph")
        .call(d3.axisLeft(y));  

    svg.append("path")
        .datum(data)
        .attr("class", "line")
        .attr("d", line);

    svg.append("path")
       .datum(data)
       .attr("class", "area")
       .attr("d", area);

    svg.selectAll("dot")
       .data(data)
       .enter().append("circle")
       .attr("class", "dot")
       .attr("style", "border: solid 2px #fff;")
       .attr("r", 5)
       .attr("cx", function(d) { return x(d.date); })
       .attr("cy", function(d) { return y(d.close); });
  }

  return {
    generateSimpleLineGraph
  }

})