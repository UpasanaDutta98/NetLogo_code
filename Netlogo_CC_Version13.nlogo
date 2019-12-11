extensions[nw csv ]
globals[cc nodeCount edgeCount mat]
links-own[weight]
turtles-own [typeNode verNo ticks_lived lifetime selected done start max_mylinks];;typeNode=old,new

to setup1
  let i 200
  while[ i > 0]
  [
    setup
    set i i - 1
  ]
end
to setup
  clear-all
  clear-ticks
  reset-ticks
  set-default-shape turtles "circle"
  crt n[
    set xcor random-xcor
    set ycor random-ycor
    set typeNode "old"
    set label "notconn"
    set ticks_lived 1
    set lifetime int(random-normal Mean_V Stand_D)
    ;output-print(word lifetime)
    set selected 0
    set done 0
    set start 0
    set max_mylinks int(random-poisson Poisson_M)
    ;output-print(word "linksmax = " max_mylinks)
  ]
  ;;set max_mylinks max_degree
  ;set P Papers
  ;set A Authors
  ;set maxW 0
  ;;At the start of the model run, before the first tick, seed * (n choose 2) number of edges are randomly added
  ;;Then repeatedly.....
  ;;     1) Arrival of vertices (as specified by f_a)
  ;;     2) Addition of edges due to connection between vertices as specified by p_oo,p_no,p_nn
  let j 0
  while [any? turtles with [label = "notconn"]]
  [
    let authors 0
    let k random 10
    ifelse k <= 8
    [set authors ((random 4) + 2)]
    [set authors ((random 2) + 6)]
    ;output-print(word "number of authors to be chosen = " authors1)
    let b count turtles with [selected = 0 and w_degree <= max_mylinks]
    ;output-print(word "number of notconn turtles = " count turtles with [label = "notconn"])
    ;output-print(word "number of turtles = " count turtles)
    ;output-print(word "number of authors selected=0 = " count turtles with [selected = 0])
    ;output-print(word "number of authors allowable = " count turtles with [w_degree <= max_mylinks])
    if authors > b
    [
     set authors b
    ]
    let w authors
    while[authors > 0]
    [
      ask one-of turtles with [selected = 0 and w_degree <= max_mylinks] ;;;;;;;
      [
        set selected 1
        set start 1
      ]
      set authors authors - 1
    ]
    let countE 0
    let authors1 w
    while[authors1 > 0]
    [
      ask one-of turtles with [selected = 1 and start = 1] ;;and w_degree <= max_mylinks
      [
        let id1 who
        let m (authors1 - 1)
        while[ m > 0 ]
        [
          let id2 [who] of one-of other turtles with [selected = 1 and done = 0] ;;and w_degree <= max_mylinks
          set countE countE + 1
          ifelse is-link? link id1 id2
          [
            ask link-with turtle id2
            [
              set weight weight + 1
            ]
          ]
          [
            create-link-with turtle id2
            ask link-with turtle id2
            [
              set weight 1
            ]
          ]
          set label "conn"
        ;;  ask turtle randomVer1[;;;output-print (word w_degree)]
          ask turtle id2[set label "conn"]
          ask turtle id2[set done 1]
          set m m - 1
        ]
        ask turtles with [done = 1][set done 0]
        set start 0
      ]
      set authors1 authors1 - 1
  ]
    ;output-print(word "edges added between authors = " countE)
    ask turtles with [selected = 1][set selected 0]

  ]
    output-print (word "initital edge count : " count links)
  output-print (word "initital edge count with weights : " ((sum [w_degree] of turtles) / 2))
  if any? turtles with [label = "notconn"]
  [
  output-print(word "yes for notconn turtles = " count turtles with [label = "notconn"])
  ]
    ;;;output-print (word)
end
;;we start with n nodes and ed edges
to go
  let m 0
  while[m < max_ticks ]
  [
    goForever
    set m m + 1
  ]
end

to goForever

  ;set-current-plot "clustering"
  ;clustering-coefficient
  ;plotxy ticks cc
;  ;;Calculate the CC of the present graph here.


  let ed (sum [w_degree] of turtles) / 2

  ;set maxW 0
  set-current-plot "edges"
  ;;countEdges
  plotxy ticks ed

  set-current-plot "nodes"
  countNodes
  plotxy ticks nodeCount



;  set-current-plot "clustering"
;  clustering-coefficient
;  plotxy ticks cc
;  ;;;output-print (word ticks " cc = " cc ", n = " nodeCount ", ed = " ed)
;  ;;output-print(word)
;

  let countVer count turtles
  ;output-print(word " turtles = " countVer)
  let NewVer ceiling (f_v * countVer)
  crt NewVer[
    set xcor random-xcor
    set ycor random-ycor
    set typeNode "new"
    set label "notconn"
    set ticks_lived 1
    set lifetime int(random-normal Mean_V Stand_D)
    set selected 0
    set done 0
    set start 0
  ]
;output-print(word " edges = " ed "new added = " NewVer)
 ;; let newNode count turtles with [typeNode = "new"]
  ;;let oldNode count turtles with [typeNode = "old"]


  let add_ed ceiling (seed * ed) ;;(P * Authors * (Authors - 1) / 2)

  let oldnew ceiling (add_ed * p_on)

  let oldold ceiling (add_ed * p_oo)
  ;
  ;
  ;
  ;
  ;output-print (word "#oldold added edges = " oldold)
  let newnew ceiling(add_ed * p_nn)
let totaladded 0
  let flag -1
;output-print (word " added = " add_ed)
  while[oldnew > 0 and any? turtles with [typeNode = "old" and ticks_lived <= lifetime]] ;;and w_degree <= max_mylinks, and w_degree <= max_mylinks
  [
    let authors 0
    let authors1 0
    ifelse flag = -1
    [
      set authors 0
      let k random 10
      ifelse k <= 8
      [set authors ((random 4) + 2)]
      [set authors ((random 2) + 6)]
      set authors1 authors
      ;output-print(word "oldnew number of authors to be chosen = " authors1)
      let a int(authors / 2)
      while[authors > a]
      [
        ask one-of turtles with [typeNode = "old" and ticks_lived <= lifetime and selected = 0]
        [
          set selected 1
          set start 1
        ]
        set authors authors - 1
      ]
      while[authors > 0]
      [
        ask one-of turtles with [typeNode = "new" and selected = 0]
        [
          set selected 1
          set start 1
        ]
        set authors authors - 1
      ]
    ]
    [
      ifelse flag = 0
      [
        set authors 3
        set authors1 3
        while[authors > 1]
        [
          ask one-of turtles with [typeNode = "old" and ticks_lived <= lifetime and selected = 0]
          [
            set selected 1
            set start 1
          ]
          set authors authors - 1
        ]
        while[authors > 0]
        [
          ask one-of turtles with [typeNode = "new" and selected = 0]
          [
            set selected 1
            set start 1
          ]
          set authors authors - 1
        ]
      ]
      [
        set authors 3
        set authors1 3
        while[authors > 2]
        [
          ask one-of turtles with [typeNode = "old" and ticks_lived <= lifetime and selected = 0]
          [
            set selected 1
            set start 1
          ]
          set authors authors - 1
        ]
        while[authors > 0]
        [
          ask one-of turtles with [typeNode = "new" and selected = 0]
          [
            set selected 1
            set start 1
          ]
          set authors authors - 1
        ]
      ]
    ]
    let countE 0
    while[authors1 > 0]
    [

      ask one-of turtles with [selected = 1 and start = 1] ;;and w_degree <= max_mylinks
      [
        let id1 who
        let m (authors1 - 1)
        while[ m > 0 ]
        [
          let id2 [who] of one-of other turtles with [selected = 1 and done = 0] ;;and w_degree <= max_mylinks

          ifelse typeNode = "new" and [typeNode] of turtle id2 = "new"
          [

            set newnew newnew - 1
            if newnew = 0
            [
              set flag 0

            ]
          ]
          [
            ifelse typeNode = "old" and [typeNode] of turtle id2 = "old"
            [
              set oldold oldold - 1
              if oldold = 0
              [
                set flag 1
              ]
            ]
            [
              set countE countE + 1
            ]
          ]
          ifelse is-link? link id1 id2
          [
            ask link-with turtle id2
            [
              set weight weight + 1
              set totaladded totaladded + 1
            ]
          ]
          [
            create-link-with turtle id2
            ask link-with turtle id2
            [
              set weight 1
              set totaladded totaladded + 1
            ]
          ]
          ask turtle id2[set done 1]
          set m m - 1
          set label "conn"
          ask turtle id2[set label "conn"]
        ]
        ask turtles with [done = 1][set done 0]
        set start 0


      ]
      set authors1 authors1 - 1
  ]
    ;output-print(word "edges added between authors = " countE)
    set oldnew oldnew - countE
    ;output-print(word "oldnew = " oldnew)
    ask turtles with [selected = 1][set selected 0]
  ]

  ;;;;output-print(word )
  ;output-print(word "#total added edges = " add_ed)
; output-print (word "#oldold added edges = " oldold)
  ;output-print(word "count with ticks_ lived <= D = " count turtles with [ticks_lived <= lifetime])
  while[oldold > 0 and count turtles with [typeNode = "old" and ticks_lived <= lifetime] >= 2] ;;and w_degree <= max_mylinks
  [
    let authors 0
    let k random 10
    ifelse k <= 8
    [set authors ((random 4) + 2)]
    [set authors ((random 2) + 6)]
    let authors1 authors
    ;output-print(word "number of authors to be chosen = " authors1)
    while[authors > 0]
    [
      ask one-of turtles with [typeNode = "old" and ticks_lived <= lifetime and selected = 0]
      [
        set selected 1
        set start 1
      ]
      set authors authors - 1
    ]
    let countE 0
    while[authors1 > 0]
    [
      ask one-of turtles with [selected = 1 and start = 1] ;;and w_degree <= max_mylinks
      [
        let id1 who
        let m (authors1 - 1)
        while[ m > 0 ]
        [
          let id2 [who] of one-of other turtles with [selected = 1 and done = 0] ;;and w_degree <= max_mylinks
          set countE countE + 1
          ifelse is-link? link id1 id2
          [
            ask link-with turtle id2
            [
              set weight weight + 1
              set totaladded totaladded + 1
            ]
          ]
          [
            create-link-with turtle id2
            ask link-with turtle id2
            [
              set weight 1
              set totaladded totaladded + 1
            ]
          ]
          ask turtle id2[set done 1]
          set m m - 1
        ]
        ask turtles with [done = 1][set done 0]
        set start 0
      ]
      set authors1 authors1 - 1
  ]
    ;output-print(word "edges added between authors = " countE)
    set oldold oldold - countE
    ;output-print(word "oldold = " oldold)
    ask turtles with [selected = 1][set selected 0]
  ]
 ;;;output-print (word "after oldold complete, turtles not connected - " count turtles with [label = "notconn"])
  ;let count_nc count turtles with [label = "notconn"]
;;;;output-print(word "oldold = " oldold)


  ;;;output-print (word "after oldnew2 done, turtles not connected - " count turtles with [label = "notconn"])
;output-print(word "oldnew = " oldnew)
;output-print (word "#newnew added edges = " newnew)
let i 0
let pp 1
while [pp = 1 or count turtles with [label = "notconn"] >= 1]
[
    set pp 0
   set i i + 1
  ;output-print(word "i = " i)
;;let newnew ceiling(add_ed * p_nn)
 ;; ;;;output-print (word "#newnew added edges = " newnew)
 ;; let newnew1 ceiling (0.8 * newnew)
  ;;let newnew2 ceiling (0.2 * newnew)
;;output-print(word "newnew = " newnew)
    ;output-print (word "before newnew, turtles not connected - " count turtles with [label = "notconn"])
  while[count turtles with [typeNode = "new" and label = "notconn"] >= 1 and newnew > 0]
  [
    let authors 0
    let k random 10
    ifelse k <= 8
    [set authors ((random 4) + 2)]
    [set authors ((random 2) + 6)]
    let authors1 authors
    ;output-print(word "newnew number of authors to be chosen = " authors1)
     ; output-print(word "authors that can be chosen = " count turtles with [typeNode = "new" and selected = 0])
      ;output-print(word "number of new nodes = " count turtles with [typeNode = "new"])
    let r count turtles with [typeNode = "new" and label = "notconn"]
      ;output-print(word "authors not coneccted = " r)
      ifelse r >= authors
      [
    while[authors > 0]
    [
      ask one-of turtles with [typeNode = "new" and label = "notconn" and selected = 0]
      [
        set selected 1
        set start 1
      ]
      set authors authors - 1
    ]
      ]
      [
        while[r > 0]
    [
      ask one-of turtles with [typeNode = "new" and label = "notconn" and selected = 0]
      [
        set selected 1
        set start 1
      ]
      set r r - 1
      set authors authors - 1
    ]
        while[ authors > 0]
    [
          ;output-print(word "authors = " authors)
          ;output-print(word "newnew = " newnew)
    ;output-print(word "number of new nodes = " count turtles with [typeNode = "new"])
      ask one-of turtles with [typeNode = "new" and selected = 0]
      [
        set selected 1
        set start 1
      ]
      set authors authors - 1
    ]

      ]
    let countE 0
    while[authors1 > 0]
    [
      ask one-of turtles with [selected = 1 and start = 1] ;;and w_degree <= max_mylinks
      [
        let id1 who
        let m (authors1 - 1)
        while[ m > 0 ]
        [
          let id2 [who] of one-of other turtles with [selected = 1 and done = 0] ;;and w_degree <= max_mylinks
              set countE countE + 1

          ifelse is-link? link id1 id2
          [
            ask link-with turtle id2
            [
              set weight weight + 1
                set totaladded totaladded + 1
            ]
          ]
          [
            create-link-with turtle id2
            ask link-with turtle id2
            [
              set weight 1
                set totaladded totaladded + 1
            ]
          ]
          ask turtle id2[set done 1]
          set m m - 1
          set label "conn"
          ask turtle id2[set label "conn"]
        ]
        ask turtles with [done = 1][set done 0]
        set start 0


      ]
      set authors1 authors1 - 1
  ]
    ;output-print(word "edges added between authors = " countE)
    set newnew newnew - countE
      ;output-print(word "newnew= " newnew)
    ask turtles with [selected = 1][set selected 0]
  ]

      ;output-print(word "\n\nnumber of new nodes = " count turtles with [typeNode = "new"])
  ;;;;set newnew2 newnew1 + newnew2
    while[newnew > 0] ;;and  w_degree <= max_mylinks
  [

    let authors 0
    let k random 10
    ifelse k <= 8
    [set authors ((random 4) + 2)]
    [set authors ((random 2) + 6)]
    let authors1 authors
  ;  output-print(word "2. newnew number of authors to be chosen = " authors1)
   ;   output-print(word "authors that can be chosen = " count turtles with [typeNode = "new" and selected = 0])
    ;  output-print(word "number of new nodes = " count turtles with [typeNode = "new"])
    while[authors > 0]
    [
      ask one-of turtles with [typeNode = "new" and selected = 0] ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      [
        set selected 1
        set start 1
      ]
      set authors authors - 1
      ]
    let countE 0
    while[authors1 > 0]
    [
      ask one-of turtles with [selected = 1 and start = 1] ;;and w_degree <= max_mylinks
      [
        let id1 who
        let m (authors1 - 1)
        while[ m > 0 ]
        [
          let id2 [who] of one-of other turtles with [selected = 1 and done = 0] ;;and w_degree <= max_mylinks
              set countE countE + 1

          ifelse is-link? link id1 id2
          [
            ask link-with turtle id2
            [
              set weight weight + 1
                set totaladded totaladded + 1
            ]
          ]
          [
            create-link-with turtle id2
            ask link-with turtle id2
            [
              set weight 1
                set totaladded totaladded + 1
            ]
          ]
          ask turtle id2[set done 1]
          set m m - 1
          set label "conn"
          ask turtle id2[set label "conn"]
        ]
        ask turtles with [done = 1][set done 0]
        set start 0


      ]
      set authors1 authors1 - 1
  ]
    ;output-print(word "edges added between authors = " countE)
    set newnew newnew - countE
      ;output-print(word "newnew = " newnew)
    ask turtles with [selected = 1][set selected 0]
  ]
   ;output-print (word "turtles not connected - " count turtles with [label = "notconn"])
    ;;let frac ((count turtles with [typeNode = "new" and label = "notconn"]) / (count turtles with [typeNode = "new"]))
    ;;set newnew ceiling (2 * frac * newnew)
    ;;output-print(word "newnew = " newnew)
    set newnew (2 * count turtles with [label = "notconn"])

    ;output-print (word "turtles not connected - " count turtles with [label = "notconn"] " newnew = " newnew)

]

  ;;;;;output-print (word "turtles not connected - " count turtles with [label = "notconn"])

;;;;output-print(word "newnew2 = " newnew2)
;  while [count turtles with [typeNode = "new" and label = "notconn"] > 1]
;  [
;    ask one-of turtles with [typeNode = "new" and label = "notconn"]
;      [
;        let id1 who
;        let sec one-of other turtles with [typeNode = "new" and label = "notconn"]
;        create-link-with sec
;        if w_degree > max_mylinks
;        [set label "conn"]
;        ask sec[if w_degree > max_mylinks[set label "conn"]]
;        ask link-with sec[set weight weight + 1]
;      ; ;;output-print(word "hello world")
;      ]
;  ]

    if count turtles with [typeNode = "new" and label = "notconn"] = 1
  [
    ask one-of turtles with [typeNode = "new" and label = "notconn"]
    [
      create-link-with one-of other turtles
      set label "conn"
     ;; ;;output-print(word "hello there")
    ]
  ]
  if count turtles with [label = "notconn"] >= 1
  [
   output-print(word "\n\n\n\n\n not connected turltes exists")
  ]
  ;set-current-plot "clustering"
  ;clustering-coefficient
  ;plotxy ticks cc
  output-print(word "added = " totaladded)
  output-print (word (ticks + 1) ". n = " count turtles ", ed = " ((sum [w_degree] of turtles) / 2) "\n\n\n\n")
  ;output-print(word [ticks_lived] of turtles with [who = 1])


  ;;set max_mylinks (1 + seed) * max_mylinks
  ask turtles [set ticks_lived ticks_lived + 1]
  ask turtles with [typeNode = "new"][set typeNode "old"]
  ;set P (1 +  seed) * P

  set mat []
    let kk 0
    ask turtles[
      set kk kk + 1
      set verNo kk
    ]
    ask links
    [
      let edge []
      ask both-ends[set edge fput verNo edge]
      set mat fput edge mat
    ]
    set mat fput ["Edges"] mat
    set kk count turtles
    let vk lput kk []
    set vk fput "Vertices" vk
    ask turtles
    [
      let node lput verNo []
      set node lput (word "#" who) node
      set mat fput node mat
    ]
    set mat fput vk mat
    writeFile
  tick
end

to countNodes
  set nodeCount count turtles
end
to countEdges
  set edgeCount count links
end

to-report w_degree
  report sum [weight] of my-links
end

to-report local-c
  let neighborhood link-neighbors

  let nbr-links link-set
     [my-links with [member? other-end neighborhood]] of (link-neighbors)
  ;; to find which of your neighbours are neighbours of each other, find the set of your neighbours first(neighbourhood set) and then find the links, linked
  ;; to the nodes of this set, whose other end points are also members of your neighbourhood set.

  ;; (link-neighbors with [typeNode != "notconn"]) returns a set of all the neighbours of the given turtle that are not "notconn".
  ;; [member? other-end neighborhood] return true if the other-end is a member of the "neighbourhood" set
  ;; [my-links with [member? other-end neighborhood]] will choose those links of a given turtle that return true for [member? other-end neighborhood].
  ;; so nbr-links is set of links between neighbours of a given turtle.
  let node who
  let KNN []
  ask nbr-links
  [
    let trio []
    let k [[who] of self] of both-ends ;; k is a list containing the end turtles
    foreach k [n1 -> set trio lput n1 trio]
    set trio lput node trio
    ;;output-print(word trio)
    set KNN lput trio KNN
  ]


  ;;output-print(word KNN)
  let product 0
  foreach KNN          ;; KNN is a list containing lists of trios centered at the current node
  [
    nn -> set product (product + ((([weight] of link (item 0 nn) (item 1 nn)) * ([weight] of link (item 1 nn) (item 2 nn)) * ([weight] of link (item 0 nn) (item 2 nn))) ^ (1 / 3)))
    ;;set product (([weight] of link nn[0] nn[1] ) * ( ) * ( ))
  ]
  ;set product (product / maxW)
  let kn count neighborhood
  ;; variable "product" now has the summation part of the clustering coefficient formula.
 ;; output-print(word)
  ;;;;;output-print (word kn)
  ifelse kn < 2 [report 0] ;; to avoid zero division
                [
                  ;;let cu (product / (kn * (kn - 1)))
                  ;report cu
                report (( 2 * count nbr-links) / (kn * (kn - 1)))]
                  ;;output-print (word kn "," (2 * count nbr-links) "/" (kn * (kn - 1)))
                  ;;report (( 2 * count nbr-links) / (kn * (kn - 1)))]
  ;;[report ((2 * sum [weight] of nbr-links) / (kn * (kn - 1)))]
  ; DECIDE HOW TO INCORPORATE THE WEIGHTS FOR GLOBAL CLUSTERING COEFFICIENT CALCULATION
end
to clustering-coefficient
  set cc precision (mean [local-c] of turtles) 5
  ;;set cc precision (mean [ nw:clustering-coefficient ] of turtles) 5
end

to writeFile
  ;let l length wholeNW
  let file outputFileName
  ;set i 0
  ;while [i < l]
  ;[
    let file1 ""

  ifelse ticks < 10[set file1 (word file "0" ticks ".net")]
    [set file1 (word file ticks ".net")]
    ;file-open file1
    ;(csv:to-file file1 item i wholeNW " ")
  (csv:to-file file1 mat " ")
    ;file-print item i wholeNW
    ;file-close
   ; set i i + 1
  ;]
end
@#$#@#$#@
GRAPHICS-WINDOW
643
69
1011
438
-1
-1
10.91
1
0
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
1
1
1
ticks
1.0

SLIDER
14
10
186
43
n
n
0
200
70.0
1
1
NIL
HORIZONTAL

SLIDER
14
44
186
77
seed
seed
0
1
0.25
0.01
1
NIL
HORIZONTAL

SLIDER
15
78
187
111
f_v
f_v
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
12
161
184
194
p_oo
p_oo
0
1
0.1
0.1
1
NIL
HORIZONTAL

SLIDER
11
192
183
225
p_on
p_on
0
1
0.3
0.1
1
NIL
HORIZONTAL

SLIDER
11
225
183
258
p_nn
p_nn
0
1
0.6
0.1
1
NIL
HORIZONTAL

BUTTON
13
431
86
464
setup
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
105
432
177
465
go
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

OUTPUT
210
10
629
511
12

PLOT
1070
27
1270
177
nodes
time
nodes
0.0
1.0
0.0
100.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count turtles"

PLOT
1071
190
1271
340
edges
time
edge
0.0
1.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

INPUTBOX
1025
346
1274
437
outputFileName
/home/upasana/Downloads/NetLogo 6.0.4/output_check/NEW/Graph
1
0
String

INPUTBOX
1084
447
1245
507
max_ticks
39.0
1
0
Number

BUTTON
13
471
117
504
goForever
goForever
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
11
333
183
366
Mean_V
Mean_V
0
40
15.0
1
1
NIL
HORIZONTAL

SLIDER
12
296
184
329
Stand_D
Stand_D
0
40
3.0
1
1
NIL
HORIZONTAL

SLIDER
11
371
183
404
Poisson_M
Poisson_M
0
50
10.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
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

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="p_c">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="n">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="outputFileName">
      <value value="&quot;/home/rajhansh22/netLogoCode/Output2/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="plot-required">
      <value value="&quot;no&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="p_n">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="seed">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="p_e">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="f_d">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="f_a">
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
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
