# VehiCool

`VehiCool` is a MATLAB library to animate vehicles in 3D.

It is currently under development. The current version is `0.2.0`, which is still in alpha stage.

**Beware that the API may change in the future.**

## Features

Hereafter a list of the implemented and upcoming features.

### Implemented

- Visualize single/multi-body objects in 3D (at the moment the library supports STL and scatter objects by default, but adding new ones is very easy).
- Visualize 2D tracks.
- Visualize 3D tracks. (not tested)
- Animate and/or save a video in post-processing.
- Animate and/or save a video step-by-step (i.e., one step at a time, as if it was attached to a simulation).

### Upcoming

- Deferred update of objects (i.e., asynchronous update of objects).
- Default object collections (i.e., ready-to-go multi-body systems).
- RDF tracks.

## Dependencies

This library uses the following third-party libraries.

- [`madhouse-utils`](https://github.com/DRIVEWISE/madhouse-utils) (provided as a submodule of the library).
- [`ebertolazzi/Clothoids`](https://it.mathworks.com/matlabcentral/fileexchange/64849-ebertolazzi-clothoids) (to be downloaded freely as a MATLAB package).

## Quick setup

Once you have installed the required dependencies, you can add the library to your MATLAB path by running the following command

```
addpath( genpath( 'path/to/VehiCool' ) );
```

then you can use the library by following this workflow example

```
%% Load the data
...

%% Define the scenario
track = RaceTrack( left_margin, right_margin );
car   = STLObject( car_state, ...
                   'STLPath', 'models/cars/Renault_5_Rallye_Edition/Renault_5_Rallye_Edition.stl' );
cam   = FollowerCamera( car );

%% Create and populate the scenario
scene = VehiCool();
scene.set_track( track );
scene.add_camera( cam );
scene.add_root_object( car );

%% Animate the scenario
scene.animate( time_sim(end) );
```

For a more detailed example, please refer to the [`examples`](examples/README.md) folder.

## Documentation

At the moment the documentation is not available. In the meantime, you can refer to the [`examples`](examples/README.md) folder and to the [`source code`](src) which are well documented.

## Licence

We release this library under the [BSD 2-Clause License](LICENSE).

## Authorship

Throughout this library we use the following scheme for authorship.

- Authors:
  - Name Surname of author 1
  - Name Surname of author 2
  - ...

This is written in the header of each file. The order of the authors reflects the contributions of each author to the specific file.
