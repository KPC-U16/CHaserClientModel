# ChaserClientModel
講習会用のテンプレートソースコード
要リファクタリング

## ディレクトリ構成
* model.rb モデル本体
* model-test.rb β版
* IntPosi.rb 初期行動
* Oni.rb 袋小路脱出(not 回避)
* Lecture2019/ プロ研講習会で教えたときのコード. バグ？知らんな.

## 目指す機能(実装済みは<, リファクタリング済みは-, 本体に反映済みは+)
* 初期位置を把握し最良の行動 <-+
* 斜めのアイテムの隣に行く <-+
* 真横のアイテムをとりに行く <-+
* 斜めに敵がいたら逃げる <
* 真横の敵にputする <-
* 壁にめり込まない <
* 袋小路回避
* lookする
* 相対値化(4方向どちらの情報を取得しても単一の簡単な条件分岐で制御できるようにする)

*- 表示は実装順 -*
  
## model.rbへ統合するときの変更点
- IntPosi.rb
  - 'values = target.'を 'go ='に変更

- ruby-test
  - 行動の指針を決めるフラグ '$actflg'を追加
  - その他ruby-testで新たに追加された要素などの要確認(History参照)
  
  
## めも(という名のIssues)
- 各アクションを起こす前にgetReadyを呼び出して、敵が隣接している時にインターセプトする形が良くない？

