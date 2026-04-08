#import "../../template/nycu-thesis.typ": *

#show: nycu-thesis.with(
  // ── Thesis titles ────────────────────────────────────────────────
  zh-title:       "基於深度學習的網路異常流量偵測",
  en-title:       "Deep Learning-Based Network Anomaly Traffic Detection",

  // ── Author & advisor  (en-*: (last-name, first-name)) ────────────
  zh-author:      "王大明",
  en-author:      ("Wang", "Da-Ming"),
  zh-advisor:     "吳建民",
  en-advisor:     ("Wu", "Chien-Min"),

  // ── Institution ──────────────────────────────────────────────────
  zh-university:  "國立陽明交通大學",
  en-university:  "National Yang Ming Chiao Tung University",
  zh-department:  "資訊工程學系",
  en-department:  "Department of Computer Science and Engineering",
  zh-college:     "資訊學院",
  en-college:     "College of Computer Science",
  zh-degree:      "碩士論文",
  en-degree:      "Master Thesis",
  en-degree-type: "Master of Science",
  en-field:       "Computer Science",

  // ── Dates ─────────────────────────────────────────────────────────
  // zh-date: (ROC year in Chinese numerals, month in Chinese)
  // en-date: (English month, year)
  zh-date:        ("一一三", "七"),
  en-date:        ("July", "2024"),

  // ── Keywords (5–7 items each) ─────────────────────────────────────
  zh-keywords:    ("深度學習", "網路流量", "異常偵測", "分類器", "特徵萃取"),
  en-keywords:    ("deep learning", "network traffic", "anomaly detection",
                   "classifier", "feature extraction"),

  // ── Mode ──────────────────────────────────────────────────────────
  // "draft"  — shows 初稿 watermark on every page
  // "upload" — no watermark, no PDF form pages (for library upload)
  // "print"  — no watermark, include PDF form pages (for binding)
  mode:           "draft",
)

// ── Front matter ──────────────────────────────────────────────────────

#acknowledgments[
  感謝我的指導教授吳建民博士，在研究過程中給予的耐心指導與寶貴建議。
  感謝實驗室的同學們在這段時間的陪伴與協助。
  最後，謹以此論文獻給我的家人，感謝他們長久以來的支持與鼓勵。
]

#zh-abstract[
  本論文提出一種基於深度學習的網路異常流量偵測方法。
  透過卷積神經網路與遞迴神經網路的結合，對網路封包序列進行特徵萃取，
  並於公開資料集上驗證所提方法之有效性。
  實驗結果顯示，本方法在偵測準確率上優於現有基準方法約 5\%。
]

#en-abstract[
  This thesis proposes a deep learning-based method for network anomaly
  traffic detection. By combining convolutional neural networks and
  recurrent neural networks, we extract features from packet sequences
  and validate the effectiveness of the proposed method on public datasets.
  Experimental results show that our approach outperforms existing baselines
  by approximately 5% in detection accuracy.
]

// Generates Table of Contents, List of Figures, and List of Tables.
// Place this after all front-matter sections.
#toc-section()

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MAIN BODY — page numbering resets to 1 (Arabic) at Chapter 1
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

= Introduction

在現代網路環境中，異常流量偵測是網路安全的核心課題之一。
傳統基於規則的偵測方法難以應對日益複雜的攻擊模式，因此以機器學習為基礎的方法受到廣泛關注。

== Motivation

隨著 5G 網路與物聯網（IoT）的普及，網路流量規模急速增長，
手動分析已不可行，亟需自動化偵測機制。

== Contributions

本論文的主要貢獻如下：

+ 提出一種結合 CNN 與 LSTM 的混合架構，用於序列型網路封包的特徵萃取。
+ 在 CICIDS2017 與 NSL-KDD 資料集上進行全面性的實驗評估。
+ 開源本論文的實驗程式碼與資料前處理腳本。

== Thesis Organization

本論文其餘章節組織如下：
第二章回顧相關研究；第三章介紹所提方法；
第四章呈現實驗結果；第五章作出結論。

= Related Work

== Intrusion Detection Systems

入侵偵測系統（IDS）可分為特徵比對型與異常偵測型兩大類 @ref-snort。
近年來，深度學習方法在異常偵測領域取得顯著進展 @ref-survey。

== Deep Learning for Traffic Analysis

如 @fig:arch 所示，現有研究多採用以下架構進行流量分類。

#figure(
  rect(width: 8cm, height: 4cm, fill: luma(230))[
    #align(center + horizon)[
      #text(size: 10pt)[(架構示意圖佔位)]
    ]
  ],
  caption: [典型深度學習流量分析架構],
) <fig:arch>

= Proposed Method

== System Overview

本章介紹所提之網路異常流量偵測系統。系統架構由三個主要模組組成：
資料前處理模組、特徵萃取模組及分類決策模組。

== Feature Extraction

設封包序列為 $bold(X) = {x_1, x_2, dots, x_T}$，
其中 $x_t in RR^d$ 為第 $t$ 個封包的特徵向量，$T$ 為序列長度。
最佳化目標為：

$ min_(theta) sum_(i=1)^N cal(L)(f_theta (bold(X)^((i))), y^((i))) $ <eq:objective>

== Implementation Details

實驗於 @tbl:config 所示的環境中進行。

#figure(
  table(
    columns: (auto, auto),
    align:   (left, left),
    stroke:  0.5pt,
    [*元件*],    [*規格*],
    [GPU],       [NVIDIA RTX 4090],
    [CPU],       [Intel Core i9-13900K],
    [RAM],       [64 GB DDR5],
    [Framework], [PyTorch 2.3],
  ),
  caption: [實驗環境配置],
) <tbl:config>

= Evaluation

== Datasets

本實驗採用兩個公開資料集：CICIDS2017 @ref-cicids 與 NSL-KDD。

== Results

實驗結果如 @tbl:results 所示，本方法在所有指標上均優於基準方法。

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align:   (left, center, center, center),
    stroke:  0.5pt,
    [*方法*],      [*準確率*], [*精確率*], [*召回率*],
    [SVM],         [91.2%],    [90.8%],    [91.5%],
    [Random Forest],[93.4%],   [93.1%],    [93.7%],
    [CNN-LSTM],    [96.3%],    [96.0%],    [96.5%],
    [*本方法*],    [*98.1%*],  [*97.9%*],  [*98.2%*],
  ),
  caption: [各方法在 CICIDS2017 資料集上的比較結果],
) <tbl:results>

= Conclusion

本論文提出一種基於深度學習的網路異常流量偵測方法，
透過 CNN-LSTM 混合架構有效提升偵測準確率。
實驗結果驗證所提方法之有效性，未來工作將聚焦於模型輕量化及線上學習能力的提升。

// ── References ────────────────────────────────────────────────────────
#thesis-bibliography(bibliography("references.bib", style: "ieee", title: none))

// ── Appendices ────────────────────────────────────────────────────────
// Heading numbering switches to 附錄A, 附錄B … after this line.
#show: appendix

= Dataset Preprocessing

附錄 A 描述 CICIDS2017 資料集的前處理流程，包括特徵選取與資料正規化步驟。

= Hyperparameter Tuning

附錄 B 列出超參數搜尋範圍及最終採用之設定值。
