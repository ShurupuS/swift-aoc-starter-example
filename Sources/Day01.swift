import Algorithms

struct Day01: AdventDay {
  var data: String

  var entities: [[String]] {
    data.split(separator: "\n\n").map {
      $0.split(separator: "\n").compactMap { String($0) }
    }
  }

  func part1() -> Any {
    processTicks(countRotation: false)
  }

  func part2() -> Any {
    processTicks(countRotation: true)
  }

  private func processTicks(countRotation: Bool) -> Int {
    let ticks = entities.flatMap { $0 }.map { $0.tick }
    var currentPos = 50
    var password = 0

    for tick in ticks {
      let (finalPos, zerosDuringRotation) = apply(tick: tick, from: currentPos, countRotation: countRotation)
      
      if finalPos == 0 {
        password += 1
      }
      password += zerosDuringRotation
      currentPos = finalPos
    }

    return password
  }

  private func apply(tick: Tick, from currentPos: Int, countRotation: Bool) -> (finalPos: Int, zerosDuringRotation: Int) {
    let stepOffset = tick.direction == .left ? -tick.steps : tick.steps
    let finalPos = modulo(currentPos + stepOffset, 100)
    
    let zerosDuringRotation = countRotation
      ? countZerosDuringRotation(from: currentPos, steps: tick.steps, direction: tick.direction)
      : 0
    
    return (finalPos, zerosDuringRotation)
  }

  private func countZerosDuringRotation(from currentPos: Int, steps: Int, direction: Tick.Direction) -> Int {
    (1..<steps).reduce(0) { count, k in
      let stepOffset = direction == .left ? -k : k
      let pos = modulo(currentPos + stepOffset, 100)
      return count + (pos == 0 ? 1 : 0)
    }
  }

  private func modulo(_ value: Int, _ modulus: Int) -> Int {
    ((value % modulus) + modulus) % modulus
  }
}

private extension String {
  var tick: Tick {
    .init(string: self)
  }
}

private struct Tick {
  enum Direction: String {
    case left = "L"
    case right = "R"
  }

  let direction: Direction
  let steps: Int

  init(string: String) {
    self.direction = string.first == "L" ? .left : .right
    self.steps = Int(string.dropFirst())!
  }
}
