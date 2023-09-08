複数のプログラムの起動を簡単に行うためのアプリです。マインクラフトのRTAを簡単に行うために設計されています。  

## 使い方
起動したいプログラムを選択して、Launchを実行するか、All Launchですべてのプログラムを起動します。  

### 各種ボタン
- Add　プログラムを追加
- Edit　選択されたプログラムのPathを変更
- Remove　選択されたプログラムをリストから削除
- Check　選択されたプログラムが存在するかチェック
- Launch　選択されたプログラムを起動
- All Launch　すべてのプログラムを起動
- All Close　すべてのプログラムを終了
- Close　ProgramsLauncherを終了

#### All Close
All Closeは、ProgramsLauncherでプログラムを起動した上で、ProgramsLauncherを一度も終了していない場合に動作します。  
なお、マインクラフトのプロセスは終了されません (起動時と起動後でPIDが異なるため)。  
基本的にないと思いますが、PIDが途中で同じのに置き換わると他のプログラムが予期せぬ終了をする可能性があります。

### settings.ini
起動するプログラムのPathや、バージョン情報などを保存しています。  

また、テキストエディタで編集することで変更出来る設定は以下。
- launchdelay　起動遅延。All Launch時に各プログラムを起動する間の遅延。ミリ秒で指定。デフォルトは4000。起動しない場合は増加？
- closeoption　すべてのプログラムを終了する際に、ProgramsLauncherも終了させる。デフォルトは無効 (0)。1で有効

## 仕様
- settings.iniのプログラムのPathと、アプリ内の表示はソートしているため順番が異なります。
- コードはAutoHotKey (AHK)で書かれ、スタンドアローン化しています。そのため、AHKをインストールしていない環境でも動作するはずです。  
- スタンドアローン化されたAHKはランサムウェア判定される場合があります。その際は許可するなりなんなりしてください。  
- 日本語などを含んだPathが完全に対応しているか不明です。少なくともsetting.ini内で文字化けしますが動作するようです。

## 未実装
いい方法が思いつかないので保留中。  
- 選択されたプログラムの終了

## スクリーンショット
![20230206225125](https://user-images.githubusercontent.com/97399080/216988877-4810a147-427d-495c-a4a7-9c5c99a86f39.png)
