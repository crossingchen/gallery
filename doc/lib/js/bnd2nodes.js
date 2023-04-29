// const fs = require('fs');
// const csv = require('csv-parser');

function bnd2nodes(file_raw) {
  const parents_air = [];
  const kids_air = [];
  const parents_water = [];
  const kids_water = [];
  var parent_air;
  var kid_air;
  
  // drawio.csv direct read
  
  // bnd file direct read
  // const bndFilePath = '/Users/xchen/Library/CloudStorage/OneDrive-RMI/Desktop/_storefront/oneobj/stuff/test_runs/output-instance/instanceout.bnd';
  // const bnd_file = fs.readFileSync(file_path, 'utf8').split('\n');
  // console.log(file_raw)
  bnd_lines = file_raw.split("\n")
  // console.log(bnd_lines)
  
  for (const line of bnd_lines) {
    const clean_line = line.trim();
    // console.log(clean_line)
    if (line.includes("Component Set,") && line.includes("Air Nodes")) {
      parents_air.push(clean_line.split(",").slice(-3)[0]);
      kids_air.push(clean_line.split(",").slice(-4)[0]);
      parents_air.push(clean_line.split(",").slice(-4)[0]);
      kids_air.push(clean_line.split(",").slice(-2)[0]);
    } else if ((line.includes("Component Set,") && line.includes("Water Nodes")) || (line.includes("Component Set,") && line.includes("Pipe Nodes")) || (line.includes("Component Set,") && line.includes("Plant Nodes"))) {
      parents_water.push(clean_line.split(",").slice(-3)[0]);
      kids_water.push(clean_line.split(",").slice(-4)[0]);
      parents_water.push(clean_line.split(",").slice(-4)[0]);
      kids_water.push(clean_line.split(",").slice(-2)[0]);
      console.log(clean_line)
    } else if (clean_line.includes("AirLoop Supply Connections") && !clean_line.includes("! <")) {
      parents_air.push(clean_line.split(",").slice(-1)[0]);
      kids_air.push(clean_line.split(",").slice(-3)[0]);
    } else if (clean_line.includes("AirLoop Return Connections") && !clean_line.includes("! <")) {
      parents_air.push(clean_line.split(",").slice(-3)[0]);
      kids_air.push(clean_line.split(",").slice(-1)[0]);
    } else if (clean_line.includes("Supply Air Path Node,Inlet Node")) {
      parent_air = clean_line.split(",").slice(-2)[0];
    } else if (clean_line.includes("Supply Air Path Node,Outlet Node")) {
      parents_air.push(parent_air);
      kids_air.push(clean_line.split(",").slice(-2)[0]);
    } else if (clean_line.includes("Return Air Path Node,Outlet Node")) {
      kid_air = clean_line.split(",").slice(-2)[0];
    } else if (clean_line.includes("Return Air Path Node,Inlet Node")) {
      parents_air.push(clean_line.split(",").slice(-2)[0]);
      kids_air.push(kid_air);
    } else if (clean_line.includes("Plant Loop Connector Nodes,")) {
      parents_water.push(clean_line.split(",").slice(-4)[0]);
      kids_water.push(clean_line.split(",").slice(-3)[0]);

      console.log(clean_line)
    }
  }
  // console.log(parents_water)
  // console.log(parents_air)
  return [parents_water, kids_water, parents_air, kids_air]
}
