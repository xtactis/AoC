count[x_] := If[x["EmptyQ"], 0, x["Length"]*x["PopFront"]+count[x]]

(* part 1 *)
{p1, p2} = CreateDataStructure["Deque", #] &/@ ((ToExpression@StringSplit[#, "\n"]) &/@ (Last[#] &/@ (StringSplit[#, ":\n"] &/@ StringSplit[ReadString["input.txt"], "\n\n"])))
While[Nor[p2["EmptyQ"], p1["EmptyQ"]], 
    If[p2["PeekFront"] > p1["PeekFront"],
        p2["PushBack", p2["PopFront"]]; p2["PushBack", p1["PopFront"]],
        p1["PushBack", p1["PopFront"]]; p1["PushBack", p2["PopFront"]]]
    ]
Print[Max[count[#] &/@ {p1, p2}]]

(* part 2 *)
{p1, p2} = CreateDataStructure["Deque", #] &/@ ((ToExpression@StringSplit[#, "\n"]) &/@ (Last[#] &/@ (StringSplit[#, ":\n"] &/@ StringSplit[ReadString["input.txt"], "\n\n"])))

copy[x_] := CreateDataStructure["Deque", Normal[x]]
prep[x_, n_] := (x["PopFront"]; m = x["Length"]-n; While[m > 0, x["PopBack"]; m--]; x)

(* @Miran da nije bilo tebe jos bih cekao *)
part2[p1_, p2_, sub_] := If[And[sub, Max[Normal[p1]]>Max[Normal[p2]]], Return[1],
    memo = CreateDataStructure["OrderedHashSet"];
    While[Nor[p2["EmptyQ"], p1["EmptyQ"]], 
        If[memo["MemberQ", {Normal[p1], Normal[p2]}],
            Return[1], (* player 1 wins *)
            memo["Insert", {Normal[p1], Normal[p2]}];
            If[And[p1["PeekFront"] < p1["Length"], p2["PeekFront"] < p2["Length"]],
                If[part2[prep[copy[p1], p1["PeekFront"]], prep[copy[p2], p2["PeekFront"]], True] == 2, (* recurse *)
                    p2["PushBack", p2["PopFront"]]; p2["PushBack", p1["PopFront"]],
                    p1["PushBack", p1["PopFront"]]; p1["PushBack", p2["PopFront"]]
                ],
                If[p2["PeekFront"] > p1["PeekFront"],
                    p2["PushBack", p2["PopFront"]]; p2["PushBack", p1["PopFront"]],
                    p1["PushBack", p1["PopFront"]]; p1["PushBack", p2["PopFront"]]
                ]
            ]
        ]
    ];
    If[p1["EmptyQ"], 2, 1]
]

Print[count[{p1, p2}[[part2[p1, p2, False]]]]]