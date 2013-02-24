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
    type: :random,
    spawn_ratio: 0.3, # 0 to 1
  }

end
