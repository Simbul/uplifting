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
    type: :declarative,
    events: {
      2 => [
        [:spawn_person, 2, 4],
        [:spawn_person, 2, 4],
      ],
      4 => [
        [:spawn_person, 1, 2],
        [:spawn_person, 1, 10],
      ],
      5 => [
        [:spawn_person, 4, 0],
      ],
    }
  }

end
