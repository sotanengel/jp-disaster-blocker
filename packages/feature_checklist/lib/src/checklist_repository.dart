// ignore_for_file: public_member_api_docs

import 'package:feature_checklist/src/checklist_item.dart';
import 'package:feature_checklist/src/checklist_scenario.dart';

abstract interface class ChecklistRepository {
  List<ChecklistItem> itemsFor(ChecklistScenario scenario);
}

class StaticChecklistRepository implements ChecklistRepository {
  static const _data = <ChecklistScenario, List<ChecklistItem>>{
    ChecklistScenario.earthquake: [
      ChecklistItem(id: 'eq_01', title: '身の安全を確保する', detail: 'テーブルの下など頑丈な家具の下に隠れる'),
      ChecklistItem(id: 'eq_02', title: '火の始末をする', detail: 'ガスコンロ・ストーブを消火する'),
      ChecklistItem(id: 'eq_03', title: '出口を確保する', detail: 'ドアや窓を開けて脱出経路を作る'),
      ChecklistItem(id: 'eq_04', title: 'ブロック塀・自動販売機から離れる'),
      ChecklistItem(id: 'eq_05', title: '避難袋を持って安全な場所へ移動する'),
      ChecklistItem(id: 'eq_06', title: 'ラジオや防災無線で情報収集する'),
      ChecklistItem(id: 'eq_07', title: '家族・近隣の安否確認をする'),
    ],
    ChecklistScenario.heavyRain: [
      ChecklistItem(id: 'hr_01', title: '気象警報・避難情報を確認する'),
      ChecklistItem(id: 'hr_02', title: '地下・半地下からすぐに脱出する'),
      ChecklistItem(id: 'hr_03', title: '側溝・河川・崖に近づかない'),
      ChecklistItem(id: 'hr_04', title: '早めに避難所へ移動する', detail: '夜間・浸水後は移動危険'),
      ChecklistItem(id: 'hr_05', title: '車での移動は避ける', detail: '30cm の水深で動けなくなる'),
      ChecklistItem(id: 'hr_06', title: '非常用品・貴重品をまとめる'),
    ],
    ChecklistScenario.tsunami: [
      ChecklistItem(id: 'ts_01', title: '地震を感じたらすぐに高台へ逃げる', detail: '津波警報を待たない'),
      ChecklistItem(id: 'ts_02', title: '徒歩で移動する', detail: '渋滞で車は危険'),
      ChecklistItem(id: 'ts_03', title: '海岸・川沿いから離れる'),
      ChecklistItem(id: 'ts_04', title: '津波浸水想定区域の外まで移動する'),
      ChecklistItem(id: 'ts_05', title: '一度引いた海は再び来る — 戻らない'),
      ChecklistItem(id: 'ts_06', title: '公式情報で津波警報解除を確認してから帰宅する'),
    ],
    ChecklistScenario.fire: [
      ChecklistItem(id: 'fi_01', title: '大声で「火事だ！」と周囲に知らせる'),
      ChecklistItem(id: 'fi_02', title: '消火器・バケツで初期消火（30秒が限界）'),
      ChecklistItem(id: 'fi_03', title: '119番通報する'),
      ChecklistItem(id: 'fi_04', title: '煙を吸わないよう姿勢を低くして避難'),
      ChecklistItem(id: 'fi_05', title: 'ドアを閉めて煙の拡散を遅らせる'),
      ChecklistItem(id: 'fi_06', title: 'エレベーターを使わず階段で脱出'),
      ChecklistItem(id: 'fi_07', title: '避難後は建物に戻らない'),
    ],
    ChecklistScenario.powerOut: [
      ChecklistItem(id: 'po_01', title: '懐中電灯・ランタンを点灯する'),
      ChecklistItem(id: 'po_02', title: 'ブレーカーを落として通電火災を防ぐ'),
      ChecklistItem(id: 'po_03', title: 'スマートフォンを省電力モードにする'),
      ChecklistItem(id: 'po_04', title: '冷蔵庫の開閉を最小限にする', detail: '4〜6時間は保冷可能'),
      ChecklistItem(id: 'po_05', title: '医療機器使用中の場合は医療機関へ連絡'),
      ChecklistItem(id: 'po_06', title: 'ラジオ・防災無線で情報収集する'),
      ChecklistItem(id: 'po_07', title: '電力会社の停電情報を確認する'),
    ],
  };

  @override
  List<ChecklistItem> itemsFor(ChecklistScenario scenario) =>
      _data[scenario] ?? const [];
}
