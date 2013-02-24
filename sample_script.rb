module Script

  SIMULATION = {
    ticks: 15,
  }

  ELEVATORS = {
    'lift 1' => {
      ticks_per_floor: 2,
      capacity: 10,
      floors: 10,
    },
  }

  SCRIPT = {
    2 => [
      [:spawn_dude, 2, 4],
      [:spawn_dude, 2, 4],
    ],
    4 => [
      [:spawn_dude, 1, 2],
      [:spawn_dude, 1, 10],
    ],
    5 => [
      [:spawn_dude, 4, 0],
    ],
  }

end
