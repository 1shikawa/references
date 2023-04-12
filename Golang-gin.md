# VSCODEでの環境設定
コマンドパレットを呼び出し、「>go Install」で検索 \
・「Go: Install/Update Tools」が表示されるのでクリック

# 起動コンテナに入る方法
1. docker(docker-compose)コマンド \
`docker exec -it go-container bash`

2. VSCODEのRemote Containerで入る

# プロジェクト初期化
`go mod init <project_name>`

# パッケージ：GitHubからダウンロードする時
- コマンド以外(mainパッケージではないもの) \
ソースコードにimport "github.com/hoge"を書く → $ go mod tidyを実行　→ \
go.modとgo.sumに依存関係がか書かれてダウンロード成功　（go getを使っても良い） \
`go get github.com/gin-gonic/gin@v1.7.4`

- コマンド \
$ go install → $GOPATH/binにバイナリーファイルができる (go getは使わない)

# パッケージ依存関係の整理
`go mod tidy` \
go mod tidyはgo.modとgo.sumを更新する。\
たとえば、main.goにimport "github.com/gorilla/mux"と書いてgo mod tidyをすると環境変数GOMODCACHEで指定されたディレクトリにmuxがダウンロードされ、go.modとgo.sumにmuxが追加され、muxが使えるようになる。
これがgo getを使わないライブラリのダウンロード方法である。
ちなみに、go.modとgo.sumがあってソースコード中にimportで呼び出してあれば、go run main.goの時にパッケージのインストールをGoが勝手にやってくれる。

# パッケージのアンインストール
1. moduleをimportしているコードを削除。
2. go mod tidyコマンドを実行。

# 静的ファイルやassetをシングルバイナリの実行ファイルに含める@gin
https://github.com/gin-gonic/examples/tree/master/assets-in-binary/example02

# ポインタ
1. 基本的にポインタを使うときの考え方として、\
・ 変更を加えたいとき \
・ 巨大な構造体など、値渡し(コピー)のコストが大きいと考えられるとき \
にポインタを使う。迷ったらポインタにする。

2. アスタリスク(*)はポインタ型の宣言をするときに使用する
- &演算子はメモリアドレスを指す。
- *演算子を使用することで、メモリアドレスの値を参照できる。

&は既に宣言されている変数のポインタを抽出するのに対し、\
*はポインタ型を示します。

実は、レシーバの型は「値型」か「ポインタ型」かどうかで挙動が少し変わってきます。\
値型とポインタ型のレシーバには、次のような違いがあります。
- 値型 ・・・メソッド呼び出し時に「レシーバそのもののコピー」が発生する
- ポインタ型 ・・・ ポインタ型のレシーバを受け取るため、メソッド内部で「実体」に対して変更処理を書くことが可能になる \
値型のレシーバの場合は、メソッドが呼び出されたときに レシーバそのもののコピー が発生します。\
なので、いくらメソッド内でフィールドの値を更新したとしても、これらの変更はコピーに対して行われるため、\
元の hanako 構造体には何の影響も与えることはできません。

一方で、ポインタ型のレシーバを使った場合は、レシーバそのものではなくポインタを受け取ります。受け取ったポインタを利用して、メソッドの内部で間接参照を行えば、実際の値 に対して変更を行うことができます。今回のように hanako 構造体そのものを直接操作したい場合は、この方法を利用する必要があります。

##### 値渡しと参照渡し
- 値渡し
  値渡しは、実引数に対して仮引数の値をコピーするというイメージである。 \
  main関数内のx, yとpssValue内のx, yは異なるため、関数呼び出し後の変数の値は変更されていない。
- 参照渡し
  参照渡しは、実引数が仮引数を参照するイメージである。 \
  変数x, yのポインタを仮引数に渡しているため、関数呼び出し後の変数の値が変更される。

[Golangのポインタで詰まったので備忘録](https://qiita.com/2san/items/0faa3939d55f8594393a) \
[Go、ポインタにするか値にするかの方針を考えてみた](https://qiita.com/ShintaNakama/items/274b24fc4ab4c9e4f094)

# 構造体
[Goの構造体とメソッドを図解で理解する。](https://qiita.com/sho_U/items/131de2c3295641e26a10)
```
// 映画タイトルのための構造体
type Movie struct {
	Directer string
	Title    string
	Year     int
}

// 映画情報を出力するメソッド
func (m *Movie) infoMovie() {
	// レシーバーの変数を介して、値を出力
	fmt.Printf("Title : %s, Directer : %s, Year : %d \n", m.Title, m.Directer, m.Year)
}

// レシーバについては構造体のフィールド値を更新する場合
func (m *Movie) setSubtitle(Subtitle string){
  m.Title = m.Title + Subtitle
}

// メイン関数
func main() {

	// 映画情報を格納
	movie1 := &Movie{
		Directer: "Steven Spielberg",
		Title: "Saving Private Ryan",
		Year: 1998,
	}

	// infoMovieメソッドの呼び出し
	movie1.infoMovie()

  	// setSubtitleメソッドの呼び出し
	movie1.setSubtitle()
}
```
# 組み込み関数 make と new の違い
make は、以下の参照型のデータ構造体を生成するために使用
- 「スライス（slice）」
- 「マップ（map）」
- 「チャネル（channel）」

new は、指定した型（構造体）のポインタ型を生成するために使用
```
type Person struct {
	Name string
	Age int
}

// *Person型の構造体（strcut）の生成
p := new(Person)

p.Name = Tom
p.Age = 18
```
# インターフェース
https://zenn.dev/ak/articles/1fb628d82ed79b
```
type Vehicle interface {
	Accelerate()
	Brake()
}

func drive(vehicle Vehicle) {
	vehicle.Accelerate()
	vehicle.Brake()
}
```
上記のように Vehicle 型を設定することで、 drive 関数は「 `Accelerate` と `Brake` メソッドを\
実装した型のみ引数として受け入れる」と示すことができます。
# httpリクエストを飛ばす(APIを叩く)方法
```
// request structの作成
req, _ := http.NewRequest(
    "Post",
    "https://test",
    bytes.NewBuffer([]byte("request body"),
)
// そのheaderを指定
req.Header.Add("Content-Type", "application/json")

// クライアントを初期化
var client *http.Client = &http.Client{}
//今回の動画見る感じ、これでも行ける？
client := &http.Client{}

// そこからリクエストを飛ばす
resp, _ := client.Do(req)

// そのリスポンスをprint
body, _ := ioutil.ReadAll(resp.Body)
fmt.Println(string(body))
```
# JSONの扱いについて
## MarshalとUnmarshalの違い
- Marshal
  構造体 -> Json
- Unmarshal
  Json -> 構造体

1. jsonのDecodeを行うときは、通常は標準ライブラリの json.Unmarshal メソッドを利用する
2. json.Unmarshal は、渡されたjsonのKey名と一致するStructのFieldに値を入れるが、Key名とField名が一致させられない場合は構造体タグの利用を検討する
```
type User struct {
  Id int
  Name string `json:"name"`
  Password string `json:"password"`
}

Tarou, err := json.Marshal(User{
  Id: 1
  Name: "Tarou"
  Password: "tatata1111"
})

var u User
// 第一引数に指定したJSONを、第二引数で指定したポインタへバインド保存
if err := json.Unmarshal([]byte(u), &u); err != nil {
  fmt.Println(err)
}

Name := u.Name
Password := u.Password
```

## Jsonレスポンスの扱い

1. Response Bodyを必ずCloseする \
  理由：ファイルディスクリプタの枯渇を未然に防ぐため
2. Response Bodyを読み切る \
  理由：keepAliveを維持し、パフォーマンスの悪化を未然に防ぐため
```
package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

type Post struct {
	UserId int    `json:"userId"`
	Id     int    `json:"id"`
	Title  string `json:"title"`
	Body   string `json:"body"`
}

func main() {
	var posts []Post

	resp, err := http.Get("https://jsonplaceholder.typicode.com/posts")
	if err != nil {
		fmt.Println("Error:", err)
		return
	}

  // TCPコネクションを閉じるためBodyをいじった後は必ず閉じる
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		fmt.Println("Error: status code", resp.StatusCode)
		return
	}

  // Bodyを全て読み切る
	body, _ := io.ReadAll(resp.Body)

  // Jsonを構造体にバインド
	if err := json.Unmarshal(body, &posts); err != nil {
		fmt.Println(err)
		return
	}
	fmt.Printf("%+v\n", posts)
}
```

# 並行処理
[Go の goroutine / channel は全然簡単じゃないので errgroup を使おう](https://eihigh.hatenablog.com/entry/2023/04/08/220538)
