select * from tbl_mhdh_brcd where ma_kpi = 'KPI_11';



select * from tbl_mhdh_brcd where NHOM_KH IS NOT NULL;
--

select * from tbl_mhdh_brcd_tldv_raw;

select * from tbl_mhdh_brcd_kpsc_raw where NGAY_BH BETWEEN DATE '2025-08-26' AND DATE '2025-08-27';

select ma_tinh, 'KPI_02.1' as ma_kpi, loai_kh, count(distinct bao_hong_id) as kpi_value
from tbl_mhdh_brcd_kpsc_raw
where ngay_bh between date'2025-10-19' and date'2025-10-20'
group by ma_tinh, loai_kh;


WITH daily AS (
    SELECT
        MA_TINH,
        NGAY_BH,
        COUNT(DISTINCT bao_hong_id) AS KPI_VALUE,
        TO_CHAR(NGAY_BH, 'YYYYMM') AS PERIOD_MONTH,
        TO_CHAR(NGAY_BH, 'YYYY')   AS PERIOD_YEAR
    FROM tbl_mhdh_brcd_kpsc_raw
    WHERE NGAY_BH BETWEEN DATE '2025-01-01' AND DATE '2025-08-27'
    GROUP BY MA_TINH, NGAY_BH
),
with_acc AS (
    SELECT
        d.*,
        SUM(KPI_VALUE) OVER (
            PARTITION BY MA_TINH, PERIOD_MONTH
            ORDER BY NGAY_BH
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS KPI_ACC_VALUE,
        SUM(KPI_VALUE) OVER (
            PARTITION BY MA_TINH, PERIOD_YEAR
            ORDER BY NGAY_BH
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS DL_NAM
    FROM daily d
)
SELECT
    NULL AS NHOM_KH,
    NULL AS LOAI_KH,
    KPI_VALUE,
    MA_TINH,
    'Số phiếu KPSC tiếp nhận' AS KPI_NAME,
    TO_CHAR(NGAY_BH, 'MMDD') AS PERIOD_INDEX,
    KPI_ACC_VALUE,
    'KPI_02.1' AS MA_KPI,
    'D' AS PERIOD_TYPE,
    PERIOD_YEAR,
    SYSDATE AS TG_CAP_NHAT,
    DL_NAM
FROM with_acc
WHERE NGAY_BH BETWEEN DATE '2025-08-26' AND DATE '2025-08-27'
ORDER BY MA_TINH;