; Initialize breeds for the ecosystem
breed [foxes fox]
breed [rabbits rabbit]
breed [foods food]

; Initialize internal values per turtle (not used by leaves)
turtles-own [energy
             field-of-vision
             nearest-neighbor]

; Initializes the model
to setup
  clear-all
  reset-ticks

  create-foxes fox-pop
  create-rabbits rabbit-pop
  create-foods food-init-count

  ask foods
  [
    set size 2.5
    set shape "leaf"
    set color green
    setxy random-xcor random-ycor
  ]

  ask foxes
  [
    set size 2
    set shape "wolf 5"
    set color orange
    setxy random-xcor random-ycor
    set energy 100
  ]

  ask rabbits
  [
    set size 2
    set shape "rabbit"
    set color white
    setxy random-xcor random-ycor
    set energy 100
  ]
end

; Runs the model at each time step
to go

  ;Stop the model if no foxes or rabbits are alive
  if not any? foxes or not any? rabbits [stop]

  ;Call to spawn food based on tick interval
  spawn-food

  ; Moves the foxes around and loses energy each time step
  ask foxes
  [

    ; Randomized movement and energy consumption
    ifelse coin-flip? [right random 100][left random 100]
    forward random 10
    set energy (energy - fox-energy-loss)

    ; Check if a rabbit is near to eat
    fox-field-of-vision
    if any? field-of-vision
    [
      get-nearest-turtle

      if is-rabbit? nearest-neighbor
      [
        ask nearest-neighbor [die]
        set energy (energy + fox-energy-loss)
        if energy > 100 [set energy 100]
      ]
    ]

    ; If the fox has no energy left, it dies
    ifelse energy < 1 [die]
    [
      if fox-prob-birth >= random 100 and fox-prob-birth > 0
      [
        hatch-foxes 1 [set energy 100]
      ]
    ]


  ]

  ; Moves the rabbits around and loses energy each time step
  ask rabbits
  [

    ; Randomized movement and energy consumption
    ifelse coin-flip? [right random 100][left random 100]
    forward random 5
    set energy (energy - rabbit-energy-loss)

    rabbit-field-of-vision
    if any? field-of-vision
    [
      get-nearest-turtle

      if is-food? nearest-neighbor
      [
        ask nearest-neighbor [die]
        set energy (energy + rabbit-energy-loss)
        if energy > 100 [set energy 100]
      ]
    ]

    ifelse energy < 1 [die]
    [
      if rabbit-prob-birth >= random 100 and rabbit-prob-birth > 0
      [
        hatch-rabbits 1 [set energy 100]
      ]
    ]

  ]

  tick
end

; Gets all turtles in the vision of the fox
to fox-field-of-vision
  set field-of-vision other rabbits in-radius fox-vision
end

; Gets all turtles in the vision of the rabbit
to rabbit-field-of-vision
  set field-of-vision other foods in-radius rabbit-vision
end

; Gets the nearest turtle of a current turtle if any
to get-nearest-turtle
  set nearest-neighbor min-one-of field-of-vision [distance myself]
end

; Randomizes the direction of a fox/rabbit
to-report coin-flip?
  report random 2 = 0
end

; Spawns food based on the interval setup in the sliders for food
to spawn-food
  if ticks >= food-regen-interval and ticks mod food-regen-interval = 0
  [
    create-foods food-count-regen
    [
      set size 2.5
      set shape "leaf"
      set color green
      setxy random-xcor random-ycor
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
573
25
1010
463
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
264
246
328
279
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
344
246
407
279
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
6
10
178
43
fox-pop
fox-pop
1
20
8.0
1
1
NIL
HORIZONTAL

SLIDER
6
51
178
84
rabbit-pop
rabbit-pop
1
20
20.0
1
1
NIL
HORIZONTAL

SLIDER
6
106
178
139
fox-energy-loss
fox-energy-loss
0
20
20.0
1
1
NIL
HORIZONTAL

SLIDER
5
147
177
180
rabbit-energy-loss
rabbit-energy-loss
0
20
10.0
1
1
NIL
HORIZONTAL

SLIDER
4
202
176
235
fox-prob-birth
fox-prob-birth
0
100
10.0
1
1
NIL
HORIZONTAL

SLIDER
4
243
176
276
rabbit-prob-birth
rabbit-prob-birth
0
100
15.0
1
1
NIL
HORIZONTAL

SLIDER
249
188
421
221
food-regen-interval
food-regen-interval
1
10
2.0
1
1
NIL
HORIZONTAL

SLIDER
250
104
422
137
food-init-count
food-init-count
0
20
10.0
1
1
NIL
HORIZONTAL

SLIDER
250
11
422
44
fox-vision
fox-vision
1.0
10.0
4.5
0.5
1
NIL
HORIZONTAL

SLIDER
251
51
423
84
rabbit-vision
rabbit-vision
1.0
10.0
4.5
0.5
1
NIL
HORIZONTAL

PLOT
9
302
209
452
Number of Foxes
Time
Foxes
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count foxes"

PLOT
239
300
439
450
Number of Rabbits
Time
Rabbits
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count rabbits"

SLIDER
249
147
421
180
food-count-regen
food-count-regen
0
50
3.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

A fox-rabbit-leaf ecosystem where a fox tries to eat rabbits, while rabbits try to eat the leaves.

## HOW IT WORKS

A initial population of foxes, rabbits and leaves are spawned. The animals both move and lose energy, they gain energy when a fox eats a rabbit or a rabbit eats a leaf. Each rabbit and fox have 100 energy at the start of the model. 

When they eat food, they gain the energy equivalent to one movement.

The model stops when all rabbits or foxes are gone. Comments are supplied in the code tab.

## HOW TO USE IT

fox-pop: The initial population of the foxes.
rabbit-pop: The initial population of the rabbits.

fox-energy-loss: Amount of energy lost at each time step for the foxes breed.
rabbit-energy-loss: Amount of energy lost at each time step for the rabbits breed.

fox-prob-birth: Probability of a fox to produce at a time step.
rabbit-prob-birth: Probability of a rabbit to produce at a time step.

fox-vision: The radius (in patches) of the allowable rabbits to eat (one at each time step).
rabbit-vision: The radius (in patches) of the allowable leaves to eat (one at each time step).

food-init-count: The initial number of leaves in the model upon setup.
food-count-regen: The number of leaves spawned each regeneration interval.
food-regen-interval: Regenerates the food if the tick counter is divisible by this number.

## THINGS TO NOTICE

The suggest amount of foxes are less than rabbits to get a more interactive result.

## THINGS TO TRY

Try the following parameters for somewhat unpredictable results:

fox-pop: 8
rabbit-pop: 8

fox-energy-loss: 20
rabbit-energy-loss: 10

fox-prob-birth: 10
rabbit-prob-birth: 15

fox-vision: 4.5
rabbit-vision: 4.5

food-init-count: 10
food-count-regen: 3
food-regen-interval: 2

## EXTENDING THE MODEL

To extend the model, other turtles might be added to the ecosystem to simulate more interesting interactions.

## NETLOGO FEATURES

Uses primary NetLogo features like turtles and randomness.

## CREDITS AND REFERENCES

Credits to the built-in flocking model of NetLogo under Biology.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

rabbit
false
0
Polygon -7500403 true true 61 150 76 180 91 195 103 214 91 240 76 255 61 270 76 270 106 255 132 209 151 210 181 210 211 240 196 255 181 255 166 247 151 255 166 270 211 270 241 255 240 210 270 225 285 165 256 135 226 105 166 90 91 105
Polygon -7500403 true true 75 164 94 104 70 82 45 89 19 104 4 149 19 164 37 162 59 153
Polygon -7500403 true true 64 98 96 87 138 26 130 15 97 36 54 86
Polygon -7500403 true true 49 89 57 47 78 4 89 20 70 88
Circle -16777216 true false 37 103 16
Line -16777216 false 44 150 104 150
Line -16777216 false 39 158 84 175
Line -16777216 false 29 159 57 195
Polygon -5825686 true false 0 150 15 165 15 150
Polygon -5825686 true false 76 90 97 47 130 32
Line -16777216 false 180 210 165 180
Line -16777216 false 165 180 180 165
Line -16777216 false 180 165 225 165
Line -16777216 false 180 210 210 240

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

wolf 5
false
0
Polygon -7500403 true true 135 285 165 285 270 90 30 90 135 285
Polygon -7500403 true true 270 90 225 15 180 90
Polygon -7500403 true true 30 90 75 15 120 90
Polygon -1 true false 225 150 180 195 165 165
Polygon -1 true false 75 150 120 195 135 165
Polygon -1 true false 135 285 135 255 150 240 165 255 165 285

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
