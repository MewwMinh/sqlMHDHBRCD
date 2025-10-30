--SELECT DU LIEU THANG 10/2025
with 
ngay as(
    select a.ma_tinh, b.donvi ttvt, count(distinct a.bao_hong_id) kpi_value 
    from tbl_mhdh_brcd_kpsc_raw a
    inner join tbl_mhdh_brcd_mapping_ttvt b
    on a.ma_hrm_nvkt_ql_tb = b.manhanvien
    where a.ngay_bh between to_date('10102025','ddmmyyyy') and to_date('11102025','ddmmyyyy')
    and a.chuyen_phieu not in (1, 2, 4) and a.ngay_ht is not null and a.trang_thai_bh = 6
    group by a.ma_tinh, b.donvi
    ),
lk_thang as (
    select a.ma_tinh, b.donvi ttvt, count(distinct a.bao_hong_id) kpi_value 
    from tbl_mhdh_brcd_kpsc_raw a
    inner join tbl_mhdh_brcd_mapping_ttvt b
    on a.ma_hrm_nvkt_ql_tb = b.manhanvien
    where a.ngay_bh between to_date('01102025','ddmmyyyy') and to_date('11102025','ddmmyyyy')
    and a.chuyen_phieu not in (1, 2, 4) and a.ngay_ht is not null and a.trang_thai_bh = 6
    group by a.ma_tinh, b.donvi
    ),
lk_nam as (
    select a.ma_tinh, b.donvi ttvt, count(distinct a.bao_hong_id) kpi_value 
    from tbl_mhdh_brcd_kpsc_raw a
    inner join tbl_mhdh_brcd_mapping_ttvt b
    on a.ma_hrm_nvkt_ql_tb = b.manhanvien
    where a.ngay_bh between to_date('01012025','ddmmyyyy') and to_date('11102025','ddmmyyyy')
    and a.chuyen_phieu not in (1, 2, 4) and a.ngay_ht is not null and a.trang_thai_bh = 6
    group by a.ma_tinh, b.donvi
    )

select 
    'KPI_05' as ma_kpi, 
    'Phiếu KPSC đã xử lý' as kpi_name,
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