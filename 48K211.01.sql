USE master;  
GO  
IF DB_ID (N'Weberaw') IS NOT NULL  
DROP DATABASE Weberaw;  
GO  
CREATE DATABASE Weberaw  
go
use Weberaw
go
--drop database  Weberaw

--Tao bang SANPHAM
create table SANPHAM
(
	MaSP char(6),
	TenSP nvarchar(50),
	DonVi nvarchar(10),
	NhomHang nvarchar(50),
	NSX date,
	HSD nvarchar(8),
	DonGia float,
	primary key(MaSP)
)

go 
--Tao bang KHO
create table KHO
(
	MaKho char(5),
	TenKho nvarchar(50),
	ViTri nvarchar(100),
	primary key(MaKho)
)
go 
--Tao bang NCC
create table NCC
(
	MaNCC char(6),
	TenNCC nvarchar(50),
	DiaChi nvarchar(100),
	Email  nvarchar(50),
	SDT int,
	ThongtinCK nvarchar(100),
	primary key(MaNCC)
)
go 
--Tao Bang KhoCT
create table KHOCT
(
	MaKho char(5),
	MaSP char(6),
	TonDau int,
	TonDK int,
	Primary key (MaKho,MaSP),
	foreign key (MaKho) references KHO,
	foreign key (MaSP) references SANPHAM
)
Go

--Tao bang PHIEUGIAOHANG
create table PHIEUGIAOHANG
(
	MaGH char(4),
	MaNCC char(6),
	NgayGiao date,
	VAT float,
	TongTien float,
	HinhThucTT nvarchar(20),
	primary key(MaGH),
	foreign key(MaNCC) references NCC
)
go 
--Tao bang PHIEUGIAOHANGCT 
create table PHIEUGIAOHANGCT
(
	MaGH char(4),
	MaSP char(6), 
	SoLuongCT Int,
	SoLuongT Int,
	DonGia float,
	ThanhTien Int,
	primary key (MaGH, MaSP),
	foreign key (MaSP) references SANPHAM,
	foreign key (MaGH) references PHIEUGIAOHANG
)
go 
--Tao bang PHIEUNHAPKHO
create table PHIEUNHAPKHO
(
	MaNhap char(5),
	MaKho char(5),
	NgayNhap date,
	TongTien float,
	LyDo varchar(20),
	primary key(MaNhap),
	foreign key (MaKho) references KHO
)

go 
--Tao bang PHIEUNHAPKHOCT
create table PHIEUNHAPKHOCT
(
	MaNhap char(5),
	MaSP char(6),
	SoLuong int,
	DonGia float,
	ThanhTien float,
	primary key (MaNhap, MaSP),
	foreign key (MaNhap) references PHIEUNHAPKHO,
	foreign key (MaSP) references SANPHAM
)
go 
--Tao Bang PHIEUXUATKHO
create table PHIEUXUATKHO
(
	MaXuat char(5),
	MaKho char (5),
	NgayXuat date,
	TongTien float,
	LyDo varchar(20), 
	primary key (MaXuat),
	Foreign key (MaKho) references KHO
)
go 
--Tao Bang PHIEUXUATKHOCT
create table PHIEUXUATKHOCT
(
	MaXuat char (5),
	MaSP char (6),
	SoLuong int,
	DonGia float,
	ThanhTien float,
	primary key (MaXuat,MaSP),
	foreign key (MaXuat) references PHIEUXUATKHO,
	foreign key (MaSP) references SANPHAM
)


-- Insert data

--Chay insert auto SanPham 
Go
create table BIENSANPHAM
(	MaSP char(6),
	TenSP nvarchar(50),
	DonVi nvarchar(10),
	NhomHang nvarchar(50),
	NSX date,
	HSD nvarchar(10),
	DonGia float,
	primary key(MaSP))
insert into BIENSANPHAM(MaSP,TenSP,DonVi,NhomHang,NSX,HSD,DonGia)
values('SP0001',N'Cà phê rang xay', N'Gam', N'Nguyên liệu cà phê','2024-06-12',N'12 tháng',30),
('SP0002',N'Cà phê nguyên hạt', N'Gam', N'Nguyên liệu cà phê','2023-03-15',N'6 tháng',25),
('SP0003',N'Sữa tươi', N'Hộp', N'Nguyên liệu sữa','2022-09-20',N'3 tháng',20),
('SP0004',N'Sữa đặc', N'Hộp', N'Nguyên liệu sữa','2024-01-01',N'12 tháng',35),
('SP0005',N'Đường trắng', N'Túi', N'Nguyên liệu thực phẩm','2023-05-10',N'1 tháng',40),
('SP0006',N'Bột cacao', N'Túi', N'Nguyên liệu bột','2022-11-25',N'6 tháng',28),
('SP0007',N'Siro dâu', N'Chai', N'Siro','2024-02-15',N'12 tháng',32),
('SP0008',N'Cà phê hòa tan', N'Gam', N'Nguyên liệu cà phê','2023-08-20',N'6 tháng',22),
('SP0009',N'Sữa chua', N'Hộp', N'Nguyên liệu sữa','2022-12-01',N'3 tháng',18),
('SP0010',N'Đường nâu', N'Túi', N'Nguyên liệu thực phẩm','2024-03-05',N'1 tháng',38),
('SP0011',N'Bột bánh', N'Túi', N'Nguyên liệu bột','2023-01-15',N'6 tháng',25),
('SP0012',N'Siro cam', N'Chai', N'Siro','2022-10-20',N'12 tháng',30),
('SP0013',N'Cà phê đen', N'Gam', N'Nguyên liệu cà phê','2024-05-10',N'6 tháng',28),
('SP0014',N'Sữa tươi không đường', N'Hộp', N'Nguyên liệu sữa','2023-06-01',N'3 tháng',22),
('SP0015',N'Đường trắng hạt', N'Túi', N'Nguyên liệu thực phẩm','2022-11-15',N'1 tháng',35),
('SP0016',N'Bột mì', N'Túi', N'Nguyên liệu bột','2024-02-20',N'6 tháng',20),
('SP0017',N'Siro dứa', N'Chai', N'Siro','2023-04-10',N'12 tháng',32),
('SP0018',N'Cà phê hòa tan không đường', N'Gam', N'Nguyên liệu cà phê','2022-09-15',N'6 tháng',25),
('SP0019',N'Sữa đặc có đường', N'Hộp', N'Nguyên liệu sữa','2024-01-15',N'3 tháng',30),
('SP0020',N'Đường nâu hạt', N'Túi', N'Nguyên liệu thực phẩm','2023-07-20',N'1 tháng',38),
('SP0021',N'Bột bánh mì', N'Túi', N'Nguyên liệu bột','2022-12-20',N'6 tháng',22),
('SP0022',N'Siro cam vắt', N'Chai', N'Siro','2024-03-15',N'12 tháng',35),
('SP0023',N'Cà phê rang xay không đường', N'Gam', N'Nguyên liệu cà phê','2023-02-10',N'6 tháng',28),
('SP0024',N'Sữa tươi có đường', N'Hộp', N'Nguyên liệu sữa','2022-10-01',N'3 tháng',25),
('SP0025',N'Đường trắng bột', N'Túi', N'Nguyên liệu thực phẩm','2024-04-20',N'1 tháng',32),
('SP0026',N'Bột bánh quy', N'Túi', N'Nguyên liệu bột','2023-05-15',N'6 tháng',20),
('SP0027',N'Siro dâu tây', N'Chai', N'Siro','2022-11-10',N'12 tháng',30),
('SP0028',N'Cà phê hòa tan có đường', N'Gam', N'Nguyên liệu cà phê','2024-06-15',N'6 tháng',25),
('SP0029',N'Sữa đặc không đường', N'Hộp', N'Nguyên liệu sữa','2023-03-01',N'3 tháng',22),
('SP0030',N'Đường nâu bột', N'Túi', N'Nguyên liệu thực phẩm','2022-12-15',N'1 tháng',35),
('SP0031',N'Bột bánh mì đen', N'Túi', N'Nguyên liệu bột','2024-02-10',N'6 tháng',28),
('SP0032',N'Siro cam ép', N'Chai', N'Siro','2023-07-15',N'12 tháng',32),
('SP0033',N'Cà phê rang xay có đường', N'Gam', N'Nguyên liệu cà phê','2022-09-15', N'12 tháng',40),
('SP0034',N'Cà phê hòa tan không đường', N'Gam', N'Nguyên liệu cà phê','2024-04-10',N'6 tháng',25),
('SP0035',N'Sữa tươi không đường', N'Hộp', N'Nguyên liệu sữa','2023-05-01',N'3 tháng',22),
('SP0036',N'Đường trắng hạt', N'Túi', N'Nguyên liệu thực phẩm','2022-10-20',N'1 tháng',35),
('SP0037',N'Bột bánh quy đen', N'Túi', N'Nguyên liệu bột','2024-03-15',N'6 tháng',20),
('SP0038',N'Siro dứa ép', N'Chai', N'Siro','2023-02-20',N'12 tháng',30),
('SP0039',N'Cà phê rang xay có đường', N'Gam', N'Nguyên liệu cà phê','2022-11-10',N'6 tháng',28),
('SP0040',N'Sữa đặc có đường', N'Hộp', N'Nguyên liệu sữa','2024-01-20',N'3 tháng',30),
('SP0041',N'Đường nâu bột', N'Túi', N'Nguyên liệu thực phẩm','2023-06-20',N'1 tháng',38),
('SP0042',N'Bột bánh mì trắng', N'Túi', N'Nguyên liệu bột','2022-12-10',N'6 tháng',22),
('SP0043',N'Siro cam vắt ép', N'Chai', N'Siro','2024-05-15',N'12 tháng',35),
('SP0044',N'Cà phê hòa tan có đường', N'Gam', N'Nguyên liệu cà phê','2023-04-10',N'6 tháng',25),
('SP0045',N'Sữa tươi có đường', N'Hộp', N'Nguyên liệu sữa','2022-09-15',N'3 tháng',25),
('SP0046',N'Đường trắng bột', N'Túi', N'Nguyên liệu thực phẩm','2024-02-20',N'1 tháng',32),
('SP0047',N'Bột bánh quy trắng', N'Túi', N'Nguyên liệu bột','2023-03-15',N'6 tháng',20),
('SP0048',N'Siro dâu tây ép', N'Chai', N'Siro','2022-11-20',N'12 tháng',30),
('SP0049',N'Cà phê rang xay không đường', N'Gam', N'Nguyên liệu cà phê','2024-06-20',N'6 tháng',28),
('SP0050',N'Sữa đặc không đường', N'Hộp', N'Nguyên liệu sữa','2023-02-01',N'3 tháng',22);
--
go
create or alter proc spAuto 
as
begin
	declare @MaSP char(6), @TenSP nvarchar(50),
	@DonVi nvarchar(10), @NhomHang nvarchar(10),
	@NSX date,
	@HSD nvarchar(20), @DonGia float
	declare @i int, @count int
	set @i = 1
	while @i<=1000
	begin 
	set @MaSP = 'SP' + REPLICATE(0,4-len(@i)) + cast(@i as char)
	select top 1
		@TenSP = TenSP,
		@DonVi = DonVi,
		@NhomHang = NhomHang,
		@NSX = NSX,
		@HSD = HSD,
		@DonGia = DonGia
	from BIENSANPHAM
	order by NEWID()
	insert into SANPHAM (MaSP, TenSP, DonVi, NhomHang, NSX, HSD, DonGia)
	values
	(@MaSp, @TenSP, @DonVi, @NhomHang, @NSX, @HSD, @DonGia)
	set @i+=1
	end
end
exec spAuto
select * from SANPHAM
go

-- Chay insert into KHO
create table BIENKHO
(	MaKho char(6),
	TenKho nvarchar(50),
	ViTri nvarchar(100),
	primary key(MaKho))
insert into BIENKHO(MaKho, TenKho, ViTri)
values
('K0001','Kho 1',N'123 Nguyễn Văn Linh, Quận Hải Châu, Đà Nẵng'),
('K0002','Kho 2',N'69 Lê Lợi, Quận Hải Châu, Đà Nẵng'),
('K0003','Kho 3',N'789 Nguyễn Trãi, Quận Thanh Khê, Đà Nẵng'),
('K0004','Kho 4',N'123 Nguyễn Văn Linh, Quận Hải Châu, Đà Nẵng'),
('K0005','Kho 5',N'135 Lê Lợi, Quận Hải Châu, Đà Nẵng'),
('K0006','Kho 6',N'56 Lê Lợi, Quận Hải Châu, Đà Nẵng'),
('K0007','Kho 7',N'567 Trần Hưng Đạo, Quận Thanh Khê, Đà Nẵng'),
('K0008','Kho 8',N'234 Nguyễn Thái Bình, Quận Hải Châu, Đà Nẵng'),
('K0009','Kho 9',N'901 Nguyễn Ái Quốc, Quận Sơn Trà, Đà Nẵng'),
('K0010','Kho 10',N'51 Lê Duẩn, Quận Hải Châu, Đà Nẵng'),
('K0011','Kho 11',N'321 Lê Hồng Phong, Quận Hải Châu, Đà Nẵng'),
('K0012','Kho 12',N'35 Nguyễn Tất Thành, Quận Thanh Khê, Đà Nẵng'),
('K0013','Kho 13',N'22 Trần Phú, Quận Hải Châu, Đà Nẵng'),
('K0014','Kho 14',N'87 Phạm Văn Đồng, Quận Sơn Trà, Đà Nẵng'),
('K0015','Kho 15',N'9 Nguyễn Văn Cừ, Quận Hải Châu, Đà Nẵng'),
('K0016','Kho 16',N'157 Nguyễn Văn Cừ, Quận Hải Châu, Đà Nẵng'),
('K0017','Kho 17',N'67 Lê Quang Đạo, Quận Cẩm Lệ, Đà Nẵng'),
('K0018','Kho 18',N'94 Huy Cận,Quận Hải Châu, Đà Nẵng'),
('K0019','Kho 19',N'164 Nguyễn Văn Thoại, Quận Ngũ Hành Sơn, Đà Nẵng'),
('K0020','Kho 20',N'05 Trần Hưng Đạo, Quận Sơn Trà, Đà Nẵng'),
('K0021','Kho 21',N'157 Lê Duẩn, Quận Hải Châu, Đà Nẵng'),
('K0022','Kho 22',N'48 Lê Đình Dương, Quận Hải Châu, Đà Nẵng'),
('K0023','Kho 23',N'24 Nguyễn Tri Phương, Quận Thanh Khê, Đà Nẵng'),
('K0024','Kho 24',N'81 Nguyễn Trãi, Quận Thanh Khê, Đà Nẵng'),
('K0025','Kho 25',N'7 Nguyễn Văn Linh, Quận Hải Châu, Đà Nẵng'),
('K0026','Kho 26',N'95 Nguyễn Thái Bình, Quận Hải Châu, Đà Nẵng'),
('K0027','Kho 27',N'135 Lê Quang Định, Quận Hải Châu, Đà Nẵng'),
('K0028','Kho 28',N'195 Nguyễn Thái Bình, Quận Hải Châu, Đà Nẵng'),
('K0029','Kho 29',N'68 Phạm Văn Đồng, Quận Sơn Trà, Đà Nẵng'),
('K0030','Kho 30',N'92 Trần Hưng Đạo, Quận Sơn Trà, Đà Nẵng'),
('K0031','Kho 31',N'35 Lê Quang Định, Quận Hải Châu, Đà Nẵng'),
('K0032','Kho 32',N'11 Nguyễn Xuân, Quận Hải Châu, Đà Nẵng'),
('K0033','Kho 33',N'1 Nguyễn Thái Bình, Quận Hải Châu, Đà Nẵng'),																							
('K0034','Kho 34',N'10 Lê Hồng Phong, Quận Hải Châu, Đà Nẵng'),																					
('K0035','Kho 35',N'99 Nguyễn Ái Quốc, Quận Sơn Trà, Đà Nẵng'),																							
('K0036','Kho 36',N'88 Trần Hưng Đạo, Quận Sơn Trà, Đà Nẵng'),																						
('K0037','Kho 37',N'153 Trần Cao Vân, Quận Sơn Trà, Đà Nẵng'),																				
('K0038','Kho 38',N'54 Phạm Văn Nghị, Quận Sơn Trà, Đà Nẵng'),																						
('K0039','Kho 39',N'14 Nguyễn Đình Chiểu, Quận Hải Châu, Đà Nẵng'),																							
('K0040','Kho 40',N'177 Nguyễn Tri Phương, Quận Thanh Khê, Đà Nẵng'),																							
('K0041','Kho 41',N'25 Lê Văn Duyệt, Quận Thanh Khê, Đà Nẵng'),																							
('K0042','Kho 42',N'122 Lê Độ, Quận Thanh Khê, Đà Nẵng'),																						
('K0043','Kho 43',N'36 Trần Phú, Quận Sơn Trà, Đà Nẵng'),																							
('K0044','Kho 44',N'66 Lê Anh Xuân, Quận Hải Châu, Đà Nẵng'),																							
('K0045','Kho 45',N'47 Nguyễn Văn Linh, Quận Hải Châu, Đà Nẵng'),																							
('K0046','Kho 46',N'41 Nguyễn Văn Cừ, Quận Hải Châu, Đà Nẵng'),																							
('K0047','Kho 47',N'58 Phạm Văn Đồng, Quận Sơn Trà, Đà Nẵng'),																						
('K0048','Kho 48',N'128 Trần Hưng Đạo, Quận Sơn Trà, Đà Nẵng'),																							
('K0049','Kho 49',N'147 Nguyễn Văn Linh, Quận Hải Châu, Đà Nẵng'),																							
('K0050','Kho 50',N'215 Lê Văn Duyệt, Quận Thanh Khê, Đà Nẵng')	

go
create or alter proc khoAuto
as
begin 
	declare @MaKho char(5),
	@TenKho nvarchar(50),
	@ViTri nvarchar(100)
	declare @i int
	set @i = 1
	while @i<=1000
	begin
		set @MaKho = 'K' + REPLICATE(0,3-len(@i)) + cast(@i as char)
		select top 1
		@TenKho = TenKho,
		@Vitri = ViTri
		from BIENKHO
		order by NEWID()
		insert into KHO(MaKho, TenKho, ViTri)
		values (@MaKho, @TenKho, @ViTri)
		set @i+=1
	end
end
go
exec khoAuto
select * from KHO

--Chay insert into NCC
go
create table BienNCC
(	MaNCC char(5) primary key ,
	TenNCC nvarchar(50),
	DiaChi nvarchar(100),
	Email nvarchar(50),
	SDT int,
	ThongtinCK nvarchar(100)
)
go
insert into BienNCC(MaNCC,TenNCC,DiaChi, Email,SDT, ThongtinCK)
values
    ('NCC01', N'Nhà cung cấp 01', N'123 Trần Phú, Đà Nẵng', 'ncc01@gmail.com', '0905123451', N'Ngân hàng Vietcombank, STK: 0123456789'),
    ('NCC02', N'Nhà cung cấp 02', N'456 Lê Duẩn, Đà Nẵng', 'ncc02@gmail.com', '0978123452', N'Ngân hàng BIDV, STK: 9876543210'),
    ('NCC03', N'Nhà cung cấp 03', N'789 Nguyễn Văn Linh, Đà Nẵng', 'ncc03@gmail.com', '0919123453', N'Ngân hàng Techcombank, STK: 1234567890'),
    ('NCC04', N'Nhà cung cấp 04', N'101 Bạch Đằng, Đà Nẵng', 'ncc04@gmail.com', '0903123454', N'Ngân hàng Sacombank, STK: 0987654321'),
    ('NCC05', N'Nhà cung cấp 05', N'102 Nguyễn Văn Cừ, Đà Nẵng', 'ncc05@gmail.com', '0915123455', N'Ngân hàng ACB, STK: 1231231231'),
    ('NCC06', N'Nhà cung cấp 06', N'103 Điện Biên Phủ, Đà Nẵng', 'ncc06@gmail.com', '0905123456', N'Ngân hàng MB, STK: 4564564564'),
    ('NCC07', N'Nhà cung cấp 07', N'104 Hùng Vương, Đà Nẵng', 'ncc07@gmail.com', '0979123457', N'Ngân hàng SHB, STK: 7897897897'),
    ('NCC08', N'Nhà cung cấp 08', N'105 Lý Thường Kiệt, Đà Nẵng', 'ncc08@gmail.com', '0919123458', N'Ngân hàng TPBank, STK: 1472583690'),
    ('NCC09', N'Nhà cung cấp 09', N'106 Ông Ích Khiêm, Đà Nẵng', 'ncc09@gmail.com', '0903123459', N'Ngân hàng Vietinbank, STK: 3692581470'),
    ('NCC10', N'Nhà cung cấp 10', N'107 Phan Chu Trinh, Đà Nẵng', 'ncc10@gmail.com', '0915123460', N'Ngân hàng ABBank, STK: 2581473690'),

    ('NCC11', N'Nhà cung cấp 11', N'108 Nguyễn Thị Minh Khai, Đà Nẵng', 'ncc11@gmail.com', '0905123461', N'Ngân hàng SeABank, STK: 1122334455'),
    ('NCC12', N'Nhà cung cấp 12', N'109 Hải Phòng, Đà Nẵng', 'ncc12@gmail.com', '0978123462', N'Ngân hàng Eximbank, STK: 9988776655'),
    ('NCC13', N'Nhà cung cấp 13', N'110 Đống Đa, Đà Nẵng', 'ncc13@gmail.com', '0919123463', N'Ngân hàng VIB, STK: 4455667788'),
    ('NCC14', N'Nhà cung cấp 14', N'111 Phan Đình Phùng, Đà Nẵng', 'ncc14@gmail.com', '0903123464', N'Ngân hàng Vietcombank, STK: 5544332211'),
    ('NCC15', N'Nhà cung cấp 15', N'112 Hoàng Diệu, Đà Nẵng', 'ncc15@gmail.com', '0915123465', N'Ngân hàng BIDV, STK: 2233445566'),
    ('NCC16', N'Nhà cung cấp 16', N'113 Trưng Nữ Vương, Đà Nẵng', 'ncc16@gmail.com', '0905123466', N'Ngân hàng Techcombank, STK: 6677889900'),
    ('NCC17', N'Nhà cung cấp 17', N'114 Lê Lợi, Đà Nẵng', 'ncc17@gmail.com', '0979123467', N'Ngân hàng Sacombank, STK: 7788990011'),
    ('NCC18', N'Nhà cung cấp 18', N'115 Nguyễn Du, Đà Nẵng', 'ncc18@gmail.com', '0919123468', N'Ngân hàng ACB, STK: 8899001122'),
    ('NCC19', N'Nhà cung cấp 19', N'116 Nguyễn Hoàng, Đà Nẵng', 'ncc19@gmail.com', '0903123469', N'Ngân hàng MB, STK: 9000112233'),
    ('NCC20', N'Nhà cung cấp 20', N'117 Lý Tự Trọng, Đà Nẵng', 'ncc20@gmail.com', '0915123470', N'Ngân hàng SHB, STK: 0011223344'),

    ('NCC21', N'Nhà cung cấp 21', N'118 Phạm Văn Đồng, Đà Nẵng', 'ncc21@gmail.com', '0905123471', N'Ngân hàng TPBank, STK: 1122446688'),
    ('NCC22', N'Nhà cung cấp 22', N'119 Hàm Nghi, Đà Nẵng', 'ncc22@gmail.com', '0978123472', N'Ngân hàng Vietinbank, STK: 5566778899'),
    ('NCC23', N'Nhà cung cấp 23', N'120 Hòa Minh, Đà Nẵng', 'ncc23@gmail.com', '0919123473', N'Ngân hàng ABBank, STK: 4455778899'),
    ('NCC24', N'Nhà cung cấp 24', N'121 Hòa Khánh, Đà Nẵng', 'ncc24@gmail.com', '0903123474', N'Ngân hàng SeABank, STK: 2233445577'),
    ('NCC25', N'Nhà cung cấp 25', N'122 Sơn Trà, Đà Nẵng', 'ncc25@gmail.com', '0915123475', N'Ngân hàng Eximbank, STK: 5566889900'),
    ('NCC26', N'Nhà cung cấp 26', N'123 Ngũ Hành Sơn, Đà Nẵng', 'ncc26@gmail.com', '0905123476', N'Ngân hàng VIB, STK: 6677990011'),
    ('NCC27', N'Nhà cung cấp 27', N'124 Thanh Khê, Đà Nẵng', 'ncc27@gmail.com', '0979123477', N'Ngân hàng Vietcombank, STK: 0011224455'),
    ('NCC28', N'Nhà cung cấp 28', N'125 Hải Châu, Đà Nẵng', 'ncc28@gmail.com', '0919123478', N'Ngân hàng BIDV, STK: 8899001133'),
    ('NCC29', N'Nhà cung cấp 29', N'126 Liên Chiểu, Đà Nẵng', 'ncc29@gmail.com', '0903123479', N'Ngân hàng Techcombank, STK: 9988221144'),
    ('NCC30', N'Nhà cung cấp 30', N'127 Cẩm Lệ, Đà Nẵng', 'ncc30@gmail.com', '0915123480', N'Ngân hàng Sacombank, STK: 1122334455'),
	('NCC31', N'Nhà cung cấp 31', N'128 Trần Quý Cáp, Đà Nẵng', 'ncc31@gmail.com', '0905123481', N'Ngân hàng ACB, STK: 2345678901'),
    ('NCC32', N'Nhà cung cấp 32', N'129 Lê Hồng Phong, Đà Nẵng', 'ncc32@gmail.com', '0978123482', N'Ngân hàng MB, STK: 3456789012'),
    ('NCC33', N'Nhà cung cấp 33', N'130 Nguyễn Tri Phương, Đà Nẵng', 'ncc33@gmail.com', '0919123483', N'Ngân hàng SHB, STK: 4567890123'),
    ('NCC34', N'Nhà cung cấp 34', N'131 Hoàng Hoa Thám, Đà Nẵng', 'ncc34@gmail.com', '0903123484', N'Ngân hàng TPBank, STK: 5678901234'),
    ('NCC35', N'Nhà cung cấp 35', N'132 Nguyễn Hữu Thọ, Đà Nẵng', 'ncc35@gmail.com', '0915123485', N'Ngân hàng Vietinbank, STK: 6789012345'),
    ('NCC36', N'Nhà cung cấp 36', N'133 Đống Đa, Đà Nẵng', 'ncc36@gmail.com', '0905123486', N'Ngân hàng ABBank, STK: 7890123456'),
    ('NCC37', N'Nhà cung cấp 37', N'134 Nguyễn Văn Linh, Đà Nẵng', 'ncc37@gmail.com', '0979123487', N'Ngân hàng SeABank, STK: 8901234567'),
    ('NCC38', N'Nhà cung cấp 38', N'135 Bạch Đằng, Đà Nẵng', 'ncc38@gmail.com', '0919123488', N'Ngân hàng Eximbank, STK: 9012345678'),
    ('NCC39', N'Nhà cung cấp 39', N'136 Lê Duẩn, Đà Nẵng', 'ncc39@gmail.com', '0903123489', N'Ngân hàng VIB, STK: 0123456789'),
    ('NCC40', N'Nhà cung cấp 40', N'137 Trưng Nữ Vương, Đà Nẵng', 'ncc40@gmail.com', '0915123490', N'Ngân hàng Vietcombank, STK: 0987654321'),

    ('NCC41', N'Nhà cung cấp 41', N'138 Hùng Vương, Đà Nẵng', 'ncc41@gmail.com', '0905123491', N'Ngân hàng BIDV, STK: 1234567890'),
    ('NCC42', N'Nhà cung cấp 42', N'139 Nguyễn Văn Cừ, Đà Nẵng', 'ncc42@gmail.com', '0978123492', N'Ngân hàng Techcombank, STK: 2345678901'),
    ('NCC43', N'Nhà cung cấp 43', N'140 Điện Biên Phủ, Đà Nẵng', 'ncc43@gmail.com', '0919123493', N'Ngân hàng Sacombank, STK: 3456789012'),
    ('NCC44', N'Nhà cung cấp 44', N'141 Ông Ích Khiêm, Đà Nẵng', 'ncc44@gmail.com', '0903123494', N'Ngân hàng ACB, STK: 4567890123'),
    ('NCC45', N'Nhà cung cấp 45', N'142 Lý Thường Kiệt, Đà Nẵng', 'ncc45@gmail.com', '0915123495', N'Ngân hàng MB, STK: 5678901234'),
    ('NCC46', N'Nhà cung cấp 46', N'143 Hoàng Diệu, Đà Nẵng', 'ncc46@gmail.com', '0905123496', N'Ngân hàng SHB, STK: 6789012345'),
    ('NCC47', N'Nhà cung cấp 47', N'144 Phan Đình Phùng, Đà Nẵng', 'ncc47@gmail.com', '0979123497', N'Ngân hàng TPBank, STK: 7890123456'),
    ('NCC48', N'Nhà cung cấp 48', N'145 Nguyễn Thị Minh Khai, Đà Nẵng', 'ncc48@gmail.com', '0919123498', N'Ngân hàng Vietinbank, STK: 8901234567'),
    ('NCC49', N'Nhà cung cấp 49', N'146 Hàm Nghi, Đà Nẵng', 'ncc49@gmail.com', '0903123499', N'Ngân hàng ABBank, STK: 9012345678'),
    ('NCC50', N'Nhà cung cấp 50', N'147 Phạm Văn Đồng, Đà Nẵng', 'ncc50@gmail.com', '0915123500', N'Ngân hàng SeABank, STK: 0123456789');
go
create or alter proc nccAuto
as
begin
	declare @MaNCC char(5) ,
	@TenNCC nvarchar(50),
	@DiaChi nvarchar(100),
	@Email nvarchar(50),
	@SDT int,
	@ThongtinCK nvarchar(100)
	declare @i int
	set @i=1
	while @i <=1000
	begin
		set @MaNCC = 'CC' + REPLICATE(0,3-len(@i)) + cast(@i as char)
		select top 1
		@TenNCC = TenNCC,
		@DiaChi = DiaChi,
		@Email = Email,
		@SDT = SDT,
		@ThongtinCK = ThongtinCK 
		from BienNCC
		order by newid()
		insert into NCC(MaNCC, TenNCC, DiaChi, Email, SDT, ThongtinCK)
		values (@MaNCC,@TenNCC,@DiaChi,@Email,@SDT,@ThongtinCK)
		set @i+=1
	end
end
go
exec nccAuto
select * from NCC
go

--Chay insert auto PHIEUGIAOHANG
create or alter proc phieuGHauto
as 
begin 
	declare @MaGH char(4),
	@MaNCC char(6),
	@NgayGiao date,
	@VAT float,
	@TongTien float,
	@HinhThucTT nvarchar(20)
	declare @i int;set @i=1
	declare @startdate date; set @startdate = '2023-08-19'
	declare @enddate date; set @enddate = getdate()
	while @i<=1000
	begin 
		set @MaGH = 'G'+ REPLICATE(0,3-len(@i)) + cast(@i as char)
		select top 1
			@MaNCC = MaNCC
		from NCC
		order by newid()

		set @NgayGiao = (SELECT DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, @StartDate, @EndDate)),@StartDate))
		set @VAT = rand()*8+3
		if cast(right(@MaNCC,3) as int)%2=0
		begin
			set @HinhThucTT = 'Chuyen Khoan'
		end
		else 
		begin
			set @HinhThucTT = 'Tien Mat'
		end
		insert into PHIEUGIAOHANG(MaGH, MaNCC, NgayGiao, VAT, HinhThucTT)
		values
		(@MaGH, @MaNCC, @NgayGiao, @VAT, @HinhThucTT)
		set @i+=1
	end
end
go
exec phieuGHauto
select * from PHIEUGIAOHANG

--Chay insert auto PHIEUGIAOHANGCT
create or alter proc phieuGHCTauto
as 
begin
	declare @MaGH char(4),
	@MaSP char(6), 
	@SoLuongCT Int,
	@SoLuongT Int, 
	@DonGia float,
	@ThanhTien Int
	declare @i int;set @i=1
	declare @z int; set @z = 1
	declare @y int; set @y = 1
	set @SoLuongCT = 1 
	set @SoLuongT = 3
	while @i<=1000
	begin
	set @MaGH = 'G'+ REPLICATE(0,3-len(@i)) + cast(@i as char)
		while @z<=5
		begin
			set @MaSP = 'SP' + REPLICATE(0,4-len(@y)) + cast(@y as char)
			set @y+=1
			set @SoLuongCT = cast(rand()*100 as int)
			set  @SoLuongT = cast(rand()*80 as int)
			set @DonGia =  rand()*60+1000
			set @ThanhTien = @SoLuongCT*@DonGia
			insert into PHIEUGIAOHANGCT
			values (@MaGH, @MaSP, @SoLuongCT, @SoLuongT, @DonGia, @ThanhTien)
			set @z +=1
		end
	set @z = 1
	set @i+=1
	end
end

exec phieuGHCTauto --Se Co trung khoa nhung auto loai khoa trung ra 
select * from PHIEUGIAOHANGCT

--Chay insert auto PHIEUNHAPKHO
create or alter proc phieuNKauto
as 
begin 
	declare @MaNhap char(5),
	@MaKho char(5),
	@NgayNhap date,
	@TongTien float,
	@LyDo varchar(20)
	declare @i int; set @i=1
	declare @startdate date; set @startdate = '2023-09-17'
	declare @enddate date; set @enddate = getdate()
	while @i<=1000
	begin
		set @MaNhap = 'N'+ replicate(0,4-len(@i)) +cast(@i as char)
		select top 1 @MaKho = MaKho
		from KHO
		order by NEWID()
		set @NgayNhap = (SELECT DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, @StartDate, @EndDate)),@StartDate))
		set @LyDo = cast(cast(rand()*5 as int) as char)
		insert into PHIEUNHAPKHO (MaNhap, MaKho, NgayNhap, LyDo)
		values ( @MaNhap,@MaKho,@NgayNhap,@LyDo )
		set @i+=1
	end
end
exec phieuNKauto

--Chay insert auto PHIEUNHAPKHOCT
create or alter proc phieuNKCTauto
as
begin 
	declare @MaNhap char(5),
	@MaSP char(6),
	@SoLuong int,
	@DonGia float,
	@ThanhTien float
	declare @i int; set @i=1
	declare @z int; set @z=1
	declare @y int; set @y=1
	while @i<=500
	begin
	set @MaNhap = 'N' + REPLICATE(0,4-len(@i)) + cast(@i as char)
		while @z<3
		begin 
		set @MaSP = 'SP' + REPLICATE(0,4-len(@y)) + cast(@y as char)
		set @y+=1
		set @SoLuong = cast(rand()*50 as int)
		select @DonGia = DonGia from SANPHAM where MaSP = @MaSP
		set @ThanhTien = @SoLuong*@DonGia
		insert into PHIEUNHAPKHOCT(	MaNhap,MaSP,SoLuong ,DonGia,ThanhTien)
		values (@MaNhap, @MaSP, @SoLuong, @DonGia, @ThanhTien)
		set @z+=1
		end
	set @z=1
	set @i+=1
	end
end

select * from PHIEUNHAPKHOCT
exec phieuNKCTauto

--Chay Insert auto PHIEUXUATKHO
create or alter proc phieuXKauto
as 
begin 
	declare @MaXuat char(5),
	@MaKho char(5),
	@NgayXuat date,
	@TongTien float,
	@LyDo varchar(20)
	declare @i int; set @i=1
	declare @startdate date; set @startdate = '2023-11-17'
	declare @enddate date; set @enddate = getdate()
	while @i<=1000
	begin
		set @MaXuat = 'X'+ replicate(0,4-len(@i)) +cast(@i as char)
		select top 1 @MaKho = MaKho
		from KHO
		order by NEWID()
		set @NgayXuat = (SELECT DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, @StartDate, @EndDate)),@StartDate))
		set @LyDo = cast(cast(rand()*5 as int) as char)
		insert into PHIEUXUATKHO (MaXuat, MaKho, NgayXuat, LyDo)
		values ( @MaXuat,@MaKho,@NgayXuat,@LyDo )
		set @i+=1
	end
end

exec phieuXKauto

--Chay Insert auto PHIEUXUATKHOCT
create or alter proc phieuXKCTauto
as
begin 
	declare @MaXuat char(5),
	@MaSP char(6),
	@SoLuong int,
	@DonGia float,
	@ThanhTien float
	declare @i int; set @i=1
	declare @z int; set @z=1
	declare @y int; set @y=1
	while @i<=500
	begin
	set @MaXuat = 'X' + REPLICATE(0,4-len(@i)) + cast(@i as char)
		while @z<3
		begin 
		set @MaSP = 'SP' + REPLICATE(0,4-len(@y)) + cast(@y as char)
		set @y+=1
		set @SoLuong = cast(rand()*50 as int)
		select @DonGia = DonGia from SANPHAM where MaSP = @MaSP
		set @ThanhTien = @SoLuong*@DonGia
		insert into PHIEUXuatKHOCT(	MaXuat,MaSP,SoLuong ,DonGia,ThanhTien)
		values (@MaXuat, @MaSP, @SoLuong, @DonGia, @ThanhTien)
		set @z+=1
		end
	set @z=1
	set @i+=1
	end
end
exec phieuXKCTauto

--Chay insert auto KHOCT
create or alter proc khoCTauto 
as
begin
	declare	@MaKho char(5),
	@MaSP char(6),
	@TonDau int,
	@TonDK int
	declare @i int; set @i=1
	declare @z int; set @z=1
	declare @y int; set @y=1
	while @i<500
	begin
		set @MaKho = 'K' + REPLICATE(0,3-len(@i))+ cast(@i as char)
		while @z<4
		begin
			set @MaSP = 'SP' + REPLICATE(0,4-len(@y)) + cast(@y as char)
			set @y+=1
			set @TonDau = cast(rand()*50 as int)
			set @TonDK = cast(rand()*80 as int)
			insert into KHOCT (MaKho, MaSP, TonDau, TonDK)
			values (@MaKho, @MaSP, @TonDau, @TonDK)
			set @z+=1
		end
		set @z=1
		set @i+=1
	end
end
exec khoCTauto






select * from SANPHAM
select * from KHO
Select * from NCC
select * from KHOCT
select * from PHIEUGIAOHANG
select * from PHIEUGIAOHANGCT
select * from PHIEUNHAPKHO
select * from PHIEUNHAPKHOCT
select * from PHIEUXUATKHO
select * from PHIEUXUATKHOCT


