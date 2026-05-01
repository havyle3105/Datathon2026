# 📊 Datathon 2026 — The Gridbreaker
**Phân tích và Dự báo Doanh thu Doanh nghiệp Thời trang TMĐT Việt Nam**

> Cuộc thi Khoa học Dữ liệu do **VinTelligence — VinUniversity DS&AI Club** tổ chức  
> Vòng 1 | Kaggle: [datathon-2026-round-1](https://www.kaggle.com/competitions/datathon-2026-round-1)

---

## 👥 Nhóm tham gia

| Thành viên | Email |
|---|---|
| Mai Thi Nhu Y | byunbhhundred@gmail.com |
| Pham Thi Minh Thu | ptmingthhu01@gmail.com |
| Le Thi Ha Vy | Havy05312004@gmail.com |

---

## 📁 Cấu trúc thư mục

```
datathon-2026/
│
├── Data/                        # Dữ liệu gốc (không commit lên GitHub)
│   ├── customers.csv
│   ├── orders.csv
│   ├── order_items.csv
│   ├── payments.csv
│   ├── products.csv
│   ├── returns.csv
│   ├── reviews.csv
│   ├── shipments.csv
│   ├── geography.csv
│   ├── promotions.csv
│   ├── inventory.csv
│   ├── web_traffic.csv
│   ├── sales.csv               # Tập train: 04/07/2012 – 31/12/2022
│   └── sample_submission.csv
│
├── figures/                     # Hình ảnh EDA xuất ra từ eda.py
│   ├── 01_customer_overview.png
│   ├── 02_customer_geo_signup.png
│   ├── 03_rfm_segmentation.png
│   ├── 04_churn_return_diagnostics.png
│   ├── 05_repeat_purchase_gap.png
│   └── 06_review_satisfaction.png
│
├── eda.py                       # Toàn bộ pipeline EDA phân tích khách hàng
├── forecasting.py               # Pipeline dự báo doanh thu (XGBoost/LightGBM)
├── submission.csv               # File dự báo nộp Kaggle
├── report_datathon2026.docx     # Báo cáo chính thức (4 trang)
├── requirements.txt             # Danh sách thư viện cần cài
└── README.md
```

---

## 🗂️ Mô tả Dữ liệu

Bộ dữ liệu mô phỏng hoạt động của một doanh nghiệp thời trang TMĐT tại Việt Nam, giai đoạn **04/07/2012 – 31/12/2022**, gồm **14 file CSV** chia thành 4 lớp:

| Lớp | File | Mô tả |
|---|---|---|
| **Master** | products, customers, promotions, geography | Dữ liệu tham chiếu |
| **Transaction** | orders, order_items, payments, shipments, returns, reviews | Giao dịch |
| **Analytical** | sales | Doanh thu hàng ngày |
| **Operational** | inventory, web_traffic | Vận hành |

**Phân chia train/test cho bài toán dự báo:**

| Split | File | Giai đoạn |
|---|---|---|
| Train | `sales.csv` | 04/07/2012 – 31/12/2022 (~3.827 dòng) |
| Test | `sales_test.csv` | 01/01/2023 – 01/07/2024 (548 dòng) |

---

## 🚀 Hướng dẫn Chạy lại Kết quả

### 1. Cài đặt môi trường

```bash
pip install -r requirements.txt
```

Hoặc cài thủ công:

```bash
pip install numpy pandas matplotlib seaborn scipy scikit-learn xgboost lightgbm
```

> **Yêu cầu:** Python 3.10+. Random seed = **42** cho mọi thực nghiệm.

### 2. Đặt dữ liệu đúng thư mục

Đặt tất cả file CSV vào thư mục `Data/` (cùng cấp với `eda.py`).

### 3. Chạy EDA

```bash
python eda.py
```

Kết quả: 6 hình ảnh phân tích khách hàng xuất ra thư mục `figures/`.

### 4. Chạy mô hình dự báo

```bash
python forecasting.py
```

Kết quả: file `submission.csv` đúng định dạng Kaggle.

---

## 📊 Phần 2 — Phân tích Khách hàng (EDA)

Phân tích theo **4 cấp độ**:

### Descriptive — What happened?
- **121.930 khách hàng**, trong đó **90.246 (74,0%)** đã có đơn hàng
- Trung bình **5,3 đơn/khách**, chi tiêu trung bình **$173.757/khách**
- Tăng trưởng đều đặn: từ <100 khách đăng ký/tháng (2012) → **1.883 khách/tháng** (12/2022)
- Kênh tiếp cận chủ đạo: organic_search (29,9%), social_media (20,1%), paid_search (19,9%)

### Diagnostic — Why did it happen?
- **Champions (12,8% khách, 551.787 VND chi tiêu TB)** — nhóm giá trị cao nhất, gấp 2,25 lần Loyal
- **At Risk (12,0% khách, 168.383 VND chi tiêu TB)** — đang im lặng, nguy cơ rời bỏ cao
- Tỷ lệ trả hàng do **wrong_size chiếm 35%** (13.967/39.939 bản ghi) — vấn đề hệ thống
- Tỷ lệ huỷ đơn đồng đều **9,1–9,4%** trên mọi kênh và nhóm tuổi → mang tính hệ thống

### Predictive — What is likely to happen?
- Inter-order gap trung vị **144 ngày** → cửa sổ can thiệp win-back lý tưởng là 90–120 ngày
- Tỷ lệ mua lặp lại **74,8–75,7%** ổn định → nền tảng loyalty tốt nhưng chưa được khai thác tối đa
- Rating ổn định **3,94/5** suốt 10 năm → chất lượng sản phẩm không phải nguyên nhân churn

### Prescriptive — What should we do?
Xem chi tiết trong báo cáo [`report_datathon2026.docx`](./report_datathon2026.docx), Mục 5.

**Tóm tắt 3 ưu tiên hành động:**

| # | Vấn đề | Hành động | KPI mục tiêu |
|---|---|---|---|
| 1 | Wrong_size 35% tổng trả hàng | Bảng size chuẩn + gợi ý size cá nhân hoá | Giảm wrong_size từ 35% → <20% trong 6 tháng |
| 2 | At Risk 10.611 khách (168K VND TB) | Win-back campaign 30 ngày, phân tầng ưu đãi | Reactivation rate ≥ 20% |
| 3 | Inter-order gap 144 ngày | Loyalty tier + nhắc nhở cá nhân hoá theo lịch | Tăng purchase frequency 15% |

---

## 🤖 Phần 3 — Mô hình Dự báo Doanh thu

### Hướng tiếp cận mô hình
- Để mô hình hóa đồng thời trend + seasonality + tác động vận hành, nghiên cứu sử dụng Prophet do Meta Platforms phát triển.
- Dự báo cột `Revenue` hàng ngày cho giai đoạn 01/2023–07/2024

### Kết quả

|  | Revenue (Vali) | Revenue (Test) |
|---|---|---|---|
| MAE | 274 | 1189830 |
| RMSE | 397 | 1520244 |
| MAPE | 10.24% | 49.98% |
| R² | 0.944 |  |

---

## 📦 requirements.txt

```
numpy>=1.24
pandas>=2.0
matplotlib>=3.7
seaborn>=0.12
scipy>=1.10
scikit-learn>=1.3
xgboost>=2.0
lightgbm>=4.1
```

---

## ⚠️ Lưu ý

- Random seed = `42` đã được cố định trong toàn bộ code
- `submission.csv` phải giữ **đúng thứ tự** như `sample_submission.csv`, không được sắp xếp lại

```gitignore
# .gitignore
Data/
*.csv
__pycache__/
.ipynb_checkpoints/
figures/*.png
```

---

*Datathon 2026 — VinTelligence × VinUniversity DS&AI Club*
