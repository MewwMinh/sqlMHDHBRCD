--SELECT DU LIEU NGAY 10/10/2025

WITH daily AS (
    SELECT
        MA_TINH,
        NGAY_BH,
        NHOM_NGUYEN_NHAN, 
        COUNT(DISTINCT bao_hong_id) AS KPI_VALUE,
        TO_CHAR(NGAY_BH, 'YYYYMM') AS PERIOD_MONTH,
        TO_CHAR(NGAY_BH, 'YYYY')   AS PERIOD_YEAR
    FROM tbl_mhdh_brcd_kpsc_raw
    WHERE NGAY_BH >= DATE '2025-01-01'
    AND NGAY_BH < DATE '2025-10-11'
    AND NGAY_HT IS NOT NULL
    AND CHUYEN_PHIEU NOT IN (1, 2, 4)
    GROUP BY MA_TINH, NGAY_BH, NHOM_NGUYEN_NHAN
),
with_acc AS (
    SELECT
        d.*,
        SUM(KPI_VALUE) OVER (
            PARTITION BY MA_TINH, NHOM_NGUYEN_NHAN, PERIOD_MONTH
            ORDER BY NGAY_BH
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS KPI_ACC_VALUE,
        SUM(KPI_VALUE) OVER (
            PARTITION BY MA_TINH, NHOM_NGUYEN_NHAN, PERIOD_YEAR
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
    'Nguyên nhân KPSC toàn mạng' AS KPI_NAME,
    TO_CHAR(NGAY_BH, 'MMDD') AS PERIOD_INDEX,
    KPI_ACC_VALUE,
    'KPI_19' AS MA_KPI,
    'D' AS PERIOD_TYPE,
    PERIOD_YEAR,
    SYSDATE AS TG_CAP_NHAT,
    DL_NAM
FROM with_acc
WHERE NGAY_BH >= DATE '2025-10-01'
AND NGAY_BH < DATE '2025-10-11'
ORDER BY MA_TINH;

--SELECT DU LIEU NGAY 10/10/2025

with 
ngay as(
    select a.ma_tinh, b.donvi ttvt, count(distinct a.bao_hong_id) kpi_value 
    from tbl_mhdh_brcd_kpsc_raw a
    inner join tbl_mhdh_brcd_mapping_ttvt b
    on a.ma_hrm_nvkt_ql_tb = b.manhanvien
    where a.ngay_bh between to_date('10102025','ddmmyyyy') and to_date('11102025','ddmmyyyy')
    and a.chuyen_phieu not in (1, 2, 4) and a.ngay_ht is not null
    group by a.ma_tinh, b.donvi
    ),
lk_thang as (
    select a.ma_tinh, b.donvi ttvt, count(distinct a.bao_hong_id) kpi_value 
    from tbl_mhdh_brcd_kpsc_raw a
    inner join tbl_mhdh_brcd_mapping_ttvt b
    on a.ma_hrm_nvkt_ql_tb = b.manhanvien
    where a.ngay_bh between to_date('01102025','ddmmyyyy') and to_date('11102025','ddmmyyyy')
    and a.chuyen_phieu not in (1, 2, 4) and a.ngay_ht is not null
    group by a.ma_tinh, b.donvi
    ),
lk_nam as (
    select a.ma_tinh, b.donvi ttvt, count(distinct a.bao_hong_id) kpi_value 
    from tbl_mhdh_brcd_kpsc_raw a
    inner join tbl_mhdh_brcd_mapping_ttvt b
    on a.ma_hrm_nvkt_ql_tb = b.manhanvien
    where a.ngay_bh between to_date('01012025','ddmmyyyy') and to_date('11102025','ddmmyyyy')
    and a.chuyen_phieu not in (1, 2, 4) and a.ngay_ht is not null
    group by a.ma_tinh, b.donvi
    )

select 
    'KPI_19' as ma_kpi, 
    'Nguyên nhân KPSC toàn mạng' as kpi_name,
    a.ma_tinh, a.ttvt, a.kpi_value kpi_value, b.kpi_value kpi_acc_value, c.kpi_value dl_nam,
    'D' as period_type, 
    '1010' as period_index, --mmdd
    '2025' as period_year, 
    sysdate as tg_cap_nhat 
from ngay a
inner join lk_thang b
on a.ma_tinh = b.ma_tinh and a.ttvt = b.ttvt 
inner join lk_nam c
on a.ma_tinh = c.ma_tinh and a.ttvt = c.ttvt
order by a.ma_tinh, a.ttvt;