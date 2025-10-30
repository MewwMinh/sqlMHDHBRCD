--SELECT DU LIEU TU 01/01/2024 -> NAY

with 
ngay as(
    select a.ngay_bh, a.ma_tinh, b.donvi ttvt, count(distinct a.bao_hong_id) kpi_value 
    from tbl_mhdh_brcd_kpsc_raw a
    inner join tbl_mhdh_brcd_mapping_ttvt b
    on a.ma_hrm_nvkt_ql_tb = b.manhanvien
    where a.ngay_bh between to_date('01012024','ddmmyyyy') and sysdate
    and a.chuyen_phieu not in (1, 2, 4) and a.trang_thai_bh <> 6
    group by a.ma_tinh, b.donvi, a.ngay_bh
    ),
lk_thang as (
    select a.ma_tinh, b.donvi ttvt, count(distinct a.bao_hong_id) kpi_value 
    from tbl_mhdh_brcd_kpsc_raw a
    inner join tbl_mhdh_brcd_mapping_ttvt b
    on a.ma_hrm_nvkt_ql_tb = b.manhanvien
    where a.ngay_bh between to_date('01012024','ddmmyyyy') and sysdate
    and a.chuyen_phieu not in (1, 2, 4) and a.trang_thai_bh <> 6
    group by a.ma_tinh, b.donvi, a.ngay_bh
    ),
lk_nam as (
    select a.ma_tinh, b.donvi ttvt, count(distinct a.bao_hong_id) kpi_value 
    from tbl_mhdh_brcd_kpsc_raw a
    inner join tbl_mhdh_brcd_mapping_ttvt b
    on a.ma_hrm_nvkt_ql_tb = b.manhanvien
    where a.ngay_bh between to_date('01012024','ddmmyyyy') and sysdate
    and a.chuyen_phieu not in (1, 2, 4) and a.trang_thai_bh <> 6
    group by a.ma_tinh, b.donvi, a.ngay_bh
    )

select 
    'KPI_41' as ma_kpi, 
    'Số phiếu KPSC tồn' as kpi_name,
    a.ma_tinh, a.ttvt, a.kpi_value kpi_value, b.kpi_value kpi_acc_value, c.kpi_value dl_nam,
    'D' as period_type, 
    to_char(a.ngay_bh, 'mmdd') as period_index, --mmdd
    to_char(a.ngay_bh, 'yyyy') as period_year, 
    sysdate as tg_cap_nhat 
from ngay a
inner join lk_thang b
on a.ma_tinh = b.ma_tinh and a.ttvt = b.ttvt 
inner join lk_nam c
on a.ma_tinh = c.ma_tinh and a.ttvt = c.ttvt
order by a.ma_tinh, a.ttvt;

--dang sai