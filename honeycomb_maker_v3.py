names = [
"Aymen",
"Test",
"Gift",
]
PLACEHOLDER = "<PLACEHOLDER>"

import subprocess
from tqdm import tqdm
with tqdm(total=len(names), desc="Starting...") as pbar:
    for name in names:
        # Update progress bar with current name
        pbar.set_description(f"Processing: {name}")
        # Change PLACEHOLDER to the name in the file honeycomb_maker_v3.scad
        with open("honeycomb_maker_v3.scad", "r") as file:
            filedata = file.read()
        filedata = filedata.replace(PLACEHOLDER, name)
        # Write the file out again
        with open(f"scad/{name.replace(" ", "_")}.scad", "w") as file:
            file.write(filedata)
            
        # Generate the 3mf file
        execute_command = f"/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD --enable all --backend=manifold -o 3mf/{name.replace(" ", "_")}.3mf scad/{name.replace(" ", "_")}.scad"
        # print(execute_command)
        result = subprocess.run(execute_command.split(),
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
        
        # Optional: check if command was successful
        if result.returncode != 0:
            tqdm.write(f"❌ Failed to create `{name}`")
        pbar.update(1)
