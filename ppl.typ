#import "@preview/diagraph:0.2.1": *

#import "poster.typ": *
// #show regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]"): set text(font: "Noto Sans CJK JP") // 漢字かなカナのみ指定（ゴシック体＝サンセリフ体）

#show: poster.with(
  size: "18x24",
  title: "Postの対応問題に対する様々なアプローチ",
  authors: "大森章裕, 南出靖彦",
  departments: "東京工業大学情報理工学院",
  univ_logo: "./images/logo.png",
  // Use the following to override the default settings
  // for the poster header.
  num_columns: "2",
  univ_logo_scale: "100",
  title_font_size: "34",
  authors_font_size: "20",
  univ_logo_column_size: "4",
  title_column_size: "10",
  footer_url_font_size: "15",
  footer_text_font_size: "24",
)

#let pcp_tile(upper, lower) = {
  box(stack(
    dir: ttb,
    [#set align(center)
      #block(stroke: black, width: 1.5cm, inset: 0.2cm, [#upper])],
    [#set align(center)
      #box(stroke: black, width: 1.5cm, inset: 0.2cm, [#lower])],
  ), baseline: 15pt)
}

#let section(
  title,
  number,
  content,
  stroke_color: rgb("#d8dddd"),
  font_color: rgb("#0053d6"),
) = {
  block(
    width: 100%,
    stroke: (paint: stroke_color, thickness: 3pt),
    stack(dir: ttb, [
      #set align(left)
      #block(inset: 0.5cm, width: 100%, fill: stroke_color, [#text(
          fill: font_color,
          font: "Hiragino Kaku Gothic ProN",
          weight: "bold",
          size: 20pt,
          [
            #if number != none [#box(text(number, size: 0.9em), baseline: 2pt, stroke: font_color, inset: 2pt)] #title],
      )])
    ], [
      #set align(left)
      #block(inset: 0.5cm, [#content])
    ]),
  )
}

#let sub_title(title, fill: rgb("#309930")) = {
  text(
    font: "Hiragino Kaku Gothic ProN",
    weight: "bold",
    fill: fill,
    size: 18pt,
    [#title],
  )
}

#let indent = { h(1em) }

#section(
  "Postの対応問題とは",
  "A",
  [
    #indent「上下に文字列が書いてある #text("s", fill: red, weight: "bold") 種類のタイルを好きな枚数好きな順番で並べて,
    上下で同じ文字列を作れるか」という問題で, 決定不能.

    - *PCP[#text("s", fill: red, weight: "bold"),#text("w", fill: blue, weight: "bold")]* ... #text("s", fill: red, weight: "bold") 種類のタイル $and$ 各タイルは最長で #text("w", fill: blue, weight: "bold") 文字

    #v(20pt)

    #sub_title([例: PCP[#text("3", fill: red, weight: "bold"),#text("4", fill: blue, weight: "bold")]のインスタンス])
    #h(30pt)
    #box(stack(
      [#set align(center)
        #stack([#pcp_tile("100", "1")], [(1)], dir: { ttb }, spacing: 5pt)],
      [#set align(center)
        #stack([#pcp_tile("0", "100")], [(2)], dir: { ttb }, spacing: 5pt)],
      [#set align(center)
        #stack([#pcp_tile("1", "00")], [(3)], dir: { ttb }, spacing: 5pt)],
      dir: { ltr },
      spacing: 5pt,
    ), baseline: 25pt)

    これの解は “1311322”
    #pcp_tile("100", "1")
    #pcp_tile("1", "00")
    #pcp_tile("100", "1")
    #pcp_tile("100", "1")
    #pcp_tile("1", "00")
    #pcp_tile("0", "100")
    #pcp_tile("0", "100")

  ],
)

#section("貢献", "B", [
  #sub_title("これまでの状況")

  - PCP[2,n]は決定可能である@pcp2n
  - PCP[3,3]は残り1個@tacklepcp
  - PCP[3,4]は3170個残っている@pcp2n@RAHN2008115

  #sub_title(fill: rgb("#ee3030"), "本研究による更新")

  - PCP[3,3]は*完全解決* (以前発見されていた75タイルが最長)
    - PCP[3,4]は残り*9個*

], stroke_color: rgb("#0053d6"), font_color: rgb("#ffffff"))

#section(
  stroke_color: rgb("#ee5050"),
  font_color: rgb("#ffffff"),
  "未解決インスタンスの例", none,
  [
    #box(width: 100%, [
      #set align(center)
      #pcp_tile("1111", "110") #pcp_tile("1110", "1") #pcp_tile("1", "1111")
      #h(50pt)
      #box(baseline: 30pt, figure(
        numbering: none,
        image("./images/qr.png", width: 70pt, height: 70pt),
      ))
    ])
  ],
)
#section(
  "文字列制約としてのアプローチ", "C",
  [
    #sub_title("問題の定式化")

    $h,g: Delta^* -> Sigma^*$ ... 上段・下段を表す写像

    *例*. $h(\"1\")=\"100\"$ #h(10pt) $h(\"132\")=\"10010\"$ #h(10pt) $g(\"13\")=\"100\"$ 

    #set align(center)
    #block([*$h(x)=g(x)$ となる $x$ が存在するか?*])
    #set align(left)
    #v(20pt)
    $h, g$ はトランスデューサとして表現できる. 整数ベクトルを出力するようなトランスデューサ $v$ を考えると, 次の式は決定可能である.
    これは緩和になっているから, 非存在性を示せる.

    #set align(center)
    #block(
      [*$v circle.stroked.tiny h(x)=v circle.stroked.tiny g(x)$ となる$x$が存在するか?*],
    )
    #set align(left)
    #sub_title([$v$ の作り方])

    単語 $w$ の出現回数を数えるようなトランスデューサ$v_w$を使うことができる.
    1. 単語集合 $W=\{\}$
    2. 各単語の出現回数を出力するトランスデューサ $v$ を作る. $v(x) = (|x|_w_1,|x|_w_2,...)$ #h(70pt)  ($|x|_w_1$ は$x$における$w$の出現回数) 
    3. $v circle.stroked.tiny h(x)=v circle.stroked.tiny g(x)$ を解く
    4. $x$ が存在し, $h(x) eq.not g(x)$ なら, この $x$ をブロックするような単語を見つけ, $W$に追加.
  ],
)
#set align(left)

#section("実験", "F", [
  #table(
    columns: (1fr, auto, auto, auto),
    inset: 10pt,
    align: horizon,
    [],
    [*ベクトルの一致による緩和*],
    [*部分文字列パターン*],
    [*PDR*],
    [#text([PCP[3,4] #cite(<tacklepcp>)の残り], size: 0.8em)],
    [3041],
    [2167],
    [???],
  )
])
#section(text("参考文献", size:0.8em), none, [
  #set text(size: 12pt)
  #show bibliography: none
  #cite(<pcp2n>, form: "full")

  #cite(<tacklepcp>, form: "full")

  #cite(<RAHN2008115>, form: "full")
  #bibliography("pcp.bib")
])
#section(
  "遷移システムとしてのアプローチ", "D",
  [
    左から一枚ずつタイルを並べることを考える.
    - 状態集合: $Q={"upper", "lower"} #symbol("⨯") Sigma^*$
    - 遷移関数: $T: Q -> Q$ ... タイルを一枚並べる操作
    - 初期状態: $I = T(epsilon)$
    - $italic("Bad") = {epsilon}$

    #figure(image("./images/trsystem.png"))
    // 例えば, #pcp_tile("101", "1") の一枚だけが並んでいるとき, この状態は $("\"upper\"", "\"01\"")$ 次に,
    // もう一枚並べて #pcp_tile("101", "1") #pcp_tile("1", "0111") とすると, 状態は $("\"lower\"", "\"1\"")$ となる.
    #v(20pt)
    この遷移システムにおいて, $T$ で閉じ, $I$ を含み, $epsilon$ を含まない*正規言語*
    $italic("Inv")$ を発見したい. (正確には, 上下でそれぞれ) この $italic("Inv")$ の発見方法に幾つかの方法を検討した.
    - 正規言語を述語とするPDRによる方法
      - Interpolationが簡単に計算できるわけではないが, 反例のblockingなどは可能
      - Predicate Abstraction系は, 具体的な反例の構成が時間的に難しい
    - SATソルバによる $italic("Inv")$ の発見
      - n状態のDFAで定式化すると $n^4$ 個の変数
    - 幅優先的な場合分けによる探索
  ],
)

#section(
  "幅優先的な場合分けによる探索","E",
  [
  - 幅優先的に解を探索する方法をベースに, 各状態を積極的に正規言語で抽象化して, 閉じることを目指す.
  - $italic("Bad")$ に到達した場合, refinementはせず, バックトラック.
  - 各操作の複雑さは状態数に対して線形. スケールしやすい.

  #figure(
    raw-render(
      width: 100%,
      ```dot
                              digraph G {
                               ratio="fill";
                               size="7,2!";
                               rankdir="LR"
                        13 [label="UP,.*0.*", shape="ellipse", style="filled", fillcolor="white"]
                        13 -> 7 [style="solid"]
                        13 -> 13 [style="solid"]
                        12 [label="UP,1", shape="box", style="filled", fillcolor="white"]
                        12 -> 7 [style="dotted"]
                        20 [label="DN,11001100", shape="box", style="filled", fillcolor="white"]
                        20 -> 25 [style="dotted"]
                        1 [label="DN,100", shape="box", style="filled", fillcolor="white"]
                        1 -> 6 [style="solid"]
                        10 [label="DN,11", shape="box", style="filled", fillcolor="white"]
                        10 -> 11 [style="solid"]
                        10 -> 12 [style="solid"]
                        11 [label="DN,11100", shape="box", style="filled", fillcolor="white"]
                        11 -> 20 [style="solid"]
                        9 [label="DN,00", shape="box", style="filled", fillcolor="white"]
                        9 -> 10 [style="solid"]
                        0 [label="UP,111", shape="box", style="filled", fillcolor="white"]
                        0 -> 7 [style="dotted"]
                        6 [label="DN,001100", shape="box", style="filled", fillcolor="white"]
                        6 -> 25 [style="dotted"]
                        25 [label="DN,.*0110.*", shape="ellipse", style="filled", fillcolor="white"]
                        25 -> 25 [style="solid"]
                        7 [label="UP,.*1.*", shape="ellipse", style="filled", fillcolor="white"]
                        7 -> 7 [style="solid"]
                        7 -> 8 [style="solid"]
                        7 -> 9 [style="solid"]
                        8 [label="UP,.*00.*", shape="ellipse", style="filled", fillcolor="white"]
                        8 -> 13 [style="dotted"]
                        start -> 1 [style="solid"]
                        start [label="", shape="point"]
                        start -> 0 [style="solid"]
                        start [label="", shape="point"]      }

                                    ```,
    ),
    caption: [(3)により閉じた遷移の例 #pcp_tile(1111, 1) #pcp_tile(00, 11) #pcp_tile(1, 1100)],
  )
  #sub_title("抽象化の方針")
  #set enum(numbering: "(1)")
  + 正規言語すべて許す
  + *$.*r.*$* か *具体的な文字列* のみを許す
    - (1) より優秀. (1)は無駄な抽象化が多すぎるか
  + *部分文字列パターン* か *具体的な文字列* のみを許す
    - *部分文字列パターン*: $.*1101.*, .*011.*$
    - 状態数が増えても, 各操作の計算量は変わらない!

  #sub_title("(3)の利点")
  - 包含判定が単純な文字列の包含として判定できるという性質の良さ.
    - ex.#h(30pt) $".*1101.*" supset 11 #text("1101", fill: red) 00$ #h(30pt) $".*1101.*" supset .*11 #text("1101", fill: red) 10.*$
    - 例えば, Badに行く状態の文字列で動的にGeneralized-Suffix-Treeを構築することで
      - ある状態sが, 他のBadな状態を含んでいるかの判定: $O(|s|)$
      - Badスペースから逆向きの探索を大量に行っておいて, 枝刈りできる
  - ある状態を抽象化する方法が$|s|^2$個しかない
    - これによって, 抽象化して同じノードを指しやすい(閉じやすい).
    - 既存のノードの中から, 抽象化にあたるノードを探すのが, $O(|s|^2*c)$
  *洞察: 局所的に悪い部分列があって, それが消せないことが多い*
  ],
)
