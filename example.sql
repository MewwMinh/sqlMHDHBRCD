select * from tbl_mhdh_brcd where ma_kpi = 'KPI_41';
select * from tbl_mhdh_brcd where ma_kpi = 'KPI_18';


select * from tbl_mhdh_brcd where NHOM_KH IS NOT NULL;
--

select * from tbl_mhdh_brcd_tldv_raw;

select * from tbl_mhdh_brcd_kpsc_raw where NGAY_BH BETWEEN DATE '2025-08-26' AND DATE '2025-08-27';

select ma_tinh, 'KPI_41' as ma_kpi, loai_kh, count(distinct bao_hong_id) as kpi_value
from tbl_mhdh_brcd_kpsc_raw
where ngay_bh between date'2025-10-19' and date'2025-10-20'
group by ma_tinh, loai_kh;


with 
ngay as(
    select a.ma_tinh, b.donvi ttvt, count(distinct a.bao_hong_id) kpi_value 
    from tbl_mhdh_brcd_kpsc_raw a
    inner join tbl_mhdh_brcd_mapping_ttvt b
    on a.ma_hrm_nvkt_ql_tb = b.manhanvien
    where a.ngay_bh between to_date('10102025','ddmmyyyy') and to_date('11102025','ddmmyyyy')
    group by a.ma_tinh, b.donvi
    ),
lk_thang as (
    select a.ma_tinh, b.donvi ttvt, count(distinct a.bao_hong_id) kpi_value 
    from tbl_mhdh_brcd_kpsc_raw a
    inner join tbl_mhdh_brcd_mapping_ttvt b
    on a.ma_hrm_nvkt_ql_tb = b.manhanvien
    where a.ngay_bh between to_date('01102025','ddmmyyyy') and to_date('11102025','ddmmyyyy')
    group by a.ma_tinh, b.donvi
    ),
lk_nam as (
    select a.ma_tinh, b.donvi ttvt, count(distinct a.bao_hong_id) kpi_value 
    from tbl_mhdh_brcd_kpsc_raw a
    inner join tbl_mhdh_brcd_mapping_ttvt b
    on a.ma_hrm_nvkt_ql_tb = b.manhanvien
    where a.ngay_bh between to_date('01012025','ddmmyyyy') and to_date('11102025','ddmmyyyy')
    group by a.ma_tinh, b.donvi
    )
select a.ma_tinh, a.ttvt, a.kpi_value kpi_value, b.kpi_value kpi_acc_value, c.kpi_value dl_nam 
from ngay a
inner join lk_thang b
on a.ma_tinh = b.ma_tinh and a.ttvt = b.ttvt 
inner join lk_nam c
on a.ma_tinh = c.ma_tinh and a.ttvt = c.ttvt
order by a.ma_tinh, a.ttvt;
