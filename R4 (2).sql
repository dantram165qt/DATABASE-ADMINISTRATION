use Weberaw
go

-------------START FUNCTION------------------

--1. Dua ra ket qua la Ton_dau khi biet Makho va MaSP
/*Module 1 
Name: Fn_ton_dau
Module type: Function
Puppose: Trả về số lượng tồn đầu khi biết Mã Kho và Mã SP. 

Input: @MaSP, @MaKHo
Output: @Tồn đầu
Return Data type: int
Process: Truyền vào @MaSP, @MaKho sau đó tìm @Ton_Dau ở bảng KHOCT điều kiện MaKho=@MaKho và MaSP=@MaSP 
*/
go
CREATE or alter FUNCTION fn_ton_dau (
    @MaSP NVARCHAR(50),
    @MaKho NVARCHAR(50)
)
RETURNS INT
AS
BEGIN
    DECLARE @ton_dau INT;

    SELECT @ton_dau = TonDau 
    FROM QuanLy.KHOCT
    WHERE MaSP = @MaSP AND MaKho = @MaKho;
    RETURN ISNULL(@ton_dau, 0); 
END;
select * from QuanLy.KHOCT --26
print dbo.fn_ton_dau('SP0001','K001')
GO


--2. Dua ra nhan xet ve ton kho khi biet Makho, MaSP
/*Module 2
Name: Fn_comment_SP
Module type: Function
Puppose: Trả về Nhận xét của Số lượng tồn đầu khi biết Mã Kho và Mã SP. 
Input: @MaSP, @MaKHo
Output: @Nhận xét
Return Data type: Nvarchar
Process: 1. Dùng Module 1 của phần funtion tìm ra TonDau, Tìm ra TonDK. Cả 2 biến này đều được tìm thấy dựa vào MaSP và MaKho.
		2. Sau khi có TonDau và TonDK ta tiến hành so sánh:
			+ Nếu @TonDau > @TonDuKien thì trả về  N'Nhập thừa sản phẩm quá nhiều'
			+ Nếu @TonDau <= 0 thì trả về N'Sản phẩm trong kho đã hết'
			+ Còn lại thì trả về  N'Số lượng tồn đầu hợp lý'
*/
go
CREATE or alter FUNCTION fn_Comment_SP (
    @MaSP NVARCHAR(50),   
    @MaKho NVARCHAR(50)    
)
RETURNS NVARCHAR(255)    
AS
BEGIN
    DECLARE @TonDau INT;            
    DECLARE @TonDuKien INT;         
    DECLARE @Comment NVARCHAR(255); 
    
	SElect @TonDau = dbo.fn_ton_dau(@MaSP,@MaKho)
    FROM QuanLy.KHOCT
    WHERE MaSP = @MaSP AND MaKho = @MaKho;
    
	Select @TonDuKien = TonDK from QuanLy.KHOCT where MaSP = @MaSP AND MaKho = @MaKho;
	SET @Comment = Case when @TonDau > @TonDuKien then N'Nhập thừa sản phẩm quá nhiều'
						when @TonDau <= 0 then N'Sản phẩm trong kho đã hết'
						else N'Số lượng tồn đầu hợp lý'
					end
    RETURN @Comment; 
END;
print dbo.fn_Comment_SP('SP0001','K001')
print dbo.fn_Comment_SP('SP0009','K003')
GO


--3. Kiem tra ma xuat kho o table PHIEUXUATKHO co trong PHIEUXUATKHOCT hay khong
/*Module 3 
Name: Fn_CheckMaXuat
Module type: Function
Puppose: Trả về nhận xét Mã xuất truyền vào có tồn tại trong PHIEUXUATKHOCT hay không. 
Input: @MaXuat
Output: @Nhận xét
Return Data type: Int
Process: 1. Kiểm tra xem mà xuất có tồn tại trong bản PHIEUXUATKHO không?
			+ Nếu không, trả về kết quả là 9 (Ma Xuat không tồn tại)
			+ Nếu có, Kiểm tra xem mã xuất đó có tồn tại trong bảng PHIEUXUATKHOCT không?
				+ Nếu có, trả về 1
				+ Nếu không, trả về 0
*/

CREATE OR ALTER FUNCTION fn_CheckMaXuat (@MaXuat NVARCHAR(50))
RETURNS int             
AS
BEGIN
    DECLARE @Exists int;
    IF EXISTS (SELECT 1 FROM Phieu.XUATKHO WHERE MaXuat = @MaXuat)
    BEGIN
        IF EXISTS (SELECT 1 FROM PhieuCT.XUATKHO WHERE MaXuat = @MaXuat)
        BEGIN
            SET @Exists = 1;  
        END
        ELSE
        BEGIN
            SET @Exists = 0;  
        END
    END
    ELSE
    BEGIN
        SET @Exists = 9;
    END
    RETURN @Exists;
END;
select * from Phieu.XUATKHO
print dbo.fn_CheckMaXuat('X1111')

GO

--4
/*Module 4
Name: Fn_CheckMaNhap
Module type: Function
Puppose: Trả về nhận xét Mã xuất truyền vào có tồn tại trong PHIEUNHAPKHOCT hay không. 
Input: @MaNhap
Output: @Nhận xét
Return Data type: Int
Process: 1. Kiểm tra xem mà xuất có tồn tại trong bản PHIEUNHAPKHO không?
			+ Nếu không, trả về kết quả là 9 (Ma Nhap không tồn tại)
			+ Nếu có, Kiểm tra xem mã xuất đó có tồn tại trong bảng PHIEUNHAPKHOCT không?
				+ Nếu có, trả về 1
				+ Nếu không, trả về 0
*/
CREATE OR ALTER FUNCTION fn_CheckMaNhap (@MaNhap NVARCHAR(50))
RETURNS int             
AS
BEGIN
    DECLARE @Exists int;
    IF EXISTS (SELECT 1 FROM Phieu.NHAPKHO WHERE MaNhap = @MaNhap)
    BEGIN
        IF EXISTS (SELECT 1 FROM PhieuCT.NHAPKHO WHERE MaNhap = @MaNhap)
        BEGIN
            SET @Exists = 1;  -- Return 1 if MaXuat exists in both tables
        END
        ELSE
        BEGIN
            SET @Exists = 0;  -- Return 0 if MaXuat exists only in PHIEUXUATKHO
        END
    END
    ELSE
    BEGIN
        SET @Exists = 9;  -- Return 9 if MaXuat does not exist in PHIEUXUATKHO
    END
    RETURN @Exists;
END;
print dbo.fn_CheckMaNhap('N0999')


--Tra về só lượng sp khi biết mã xuất,mã sản phẩm
/*Module 4
Name: Fn_CountSLXuat
Module type: Function
Puppose: Trả về về só lượng sp khi biết mã xuất,mã sản phẩm. 
Input: @MaXuat, @MaSP
Output: @Số lượng
Return Data type: Int
Process:  Truyền vào @MaSP, @MaXuat sau đó tìm @SoLuong ở bảng PHIEUXUATKHOCT điều kiện MaXuat=@MaXuat và MaSP=@MaSP
*/

create or alter function CountSLXuat(@masp varchar(6), @maxuat char(5))
returns int
as
begin
	declare @countsp int
	select @countsp= SoLuong
	from PhieuCT.XUATKHO
	where MaXuat=@maxuat and MaSP=@masp
	return @countsp
end
go
select dbo.CountSLXuat('SP0001','X0001')
select * from PhieuCT.XUATKHO


/*Module 5
Name: Fn_CountSLNhap
Module type: Function
Puppose: Trả về về só lượng sp khi biết mã nhập,mã sản phẩm. 
Input: @MaNhap, @MaSP
Output: @Số lượng
Return Data type: Int
Process:  Truyền vào @MaSP, @MaNhap sau đó tìm @SoLuong ở bảng PHIEUNHAPKHOCT điều kiện MaNhap=@MaNhap và MaSP=@MaSP
*/
create function CountSLNhap(@manhap char(5), @masp char(6))
returns int
as
begin 
	declare @countspp int
	select @countspp=SoLuong
	from PhieuCT.NHAPKHO
	where MaNhap=@manhap and MaSP=@masp
	return @countspp
end
GO
select dbo.CountSLNhap('N0001','SP0001')

select * from PhieuCT.NHAPKHO
-- trả về kiểu dữ liẹu bảng: get_thanhtien(ma_xuat, ma_gh, ma_nhap) cột thành tiên
--return table 3 thành tiền where @ma_gh=ma_gh, của 3 cột chi tiết
go

/*Module 6
Name: getTongTienXK
Module type: Function
Puppose: Trả về tổng tiền Xuất hàng của đợi xuất hàng. 
Input: @MaXuat
Output: @Tongtien
Return Data type: Int
Process:  Tìm tổng tiền bằng cách tính tổng các lần thành tiền trong bảng PHIEUXUATKHOCT, điều kiện MaXuat=@MaXuat
*/
CREATE or alter FUNCTION getTongtienXK(@ma_xuat CHAR(6))
returns int
as
begin 
	declare @tongtien int
	set @tongtien = (select SUM(SoLuong*DonGia) as Tongtien
						from PhieuCT.XUATKHO
						where MaXuat=@ma_xuat)
	return @tongtien
end

select dbo.getTongtienXK('X0001')


/*Module 7
Name: getTongTienGH
Module type: Function
Puppose: Trả về tổng tiền Giao hàng của 1 đợt giao hàng. 
Input: @MaGH
Output: @Tongtien
Return Data type: Int
Process:  Tìm tổng tiền bằng cách tính tổng các lần thành tiền trong bảng PHIEUGIAOHANGCT, điều kiện MaGH=@MaGH
*/
go
CREATE FUNCTION getTongtienGH(@MaGiaoHang CHAR(5))
RETURNS int
AS
begin
	declare @Tongtien int
    set @Tongtien = (select sum(ThanhTien) AS TongTien
    FROM PhieuCT.GIAOHANG
    WHERE MaGH = @MaGiaoHang)
	return @Tongtien
end
select dbo.getTongtienGH('G001')

/*Module 8
Name: getTongTienNK
Module type: Function
Puppose: Trả về tổng tiền Nhập hàng của 1 đợt nhập hàng. 
Input: @MaNhap
Output: @Tongtien
Return Data type: Int
Process:  Tìm tổng tiền bằng cách tính tổng các lần thành tiền trong bảng PHIEUNHAPKHOCT, điều kiện MaNhap=@MaNhap
*/

CREATE FUNCTION getTongTienNK(@MaNhap CHAR(5))
RETURNS int
AS
begin
	declare @Tongtien int;
    set @Tongtien = (SELECT sum(ThanhTien) AS ThanhTien
    FROM PhieuCT.NHAPKHO
    WHERE MaNhap = @MaNhap)
	return @TongTien
end
select dbo.getTongTienNK('N0001')



-----------------------------ENDING FUNCTION----------------------------------


----------------------------START TRIGGER------------------------------------

/*
Module 1 
Name: CheckslGHCt
Module type: Trigger
Puppose: Kiểm tra mức độ đáng tin cậy của số lượng sản phẩm sau khi nhập 1 dòng giá trị của bảng PHIEUGIAOHANGCT. 
Kiểm tra xem nếu số lượng thực tế lớn hơn số lượng ghi trên chứng từ thì báo lỗi

Input: N/a
Output: N/a
- Type: After 
- Events: insert
- Table: PHIEUGIAOHANGCT
- Process: 1. Tìm SoLuongCT, SoLuongT trong bang Inserted -> @soLuongCT, @soLuongT 
			2. So sanh: - Neu @soLuongT > @soLuongCT thi in thông báo lỗi (N'Số lượng không hợp lý') và rollback.
						- Neu không thì chạy bình thường.
*/
CREATE OR ALTER TRIGGER CheckslGHCT
ON PhieuCT.GIAOHANG
FOR INSERT
AS
BEGIN
    DECLARE @soLuongCT INT,
            @soLuongT INT;
    SELECT @soLuongCT = SoLuongCT, @soLuongT= SoLuongT FROM inserted;
        IF @soLuongT > @soLuongCT 
        BEGIN
            Print(N'Số lượng không hợp lý');
            ROLLBACK TRANSACTION;
            RETURN;
        END
END;

insert into PhieuCT.GIAOHANG values('G505', 'SP0100',  45, 89, 50000, 200000)
select * from PhieuCT.GIAOHANG
select * from Phieu.GIAOHANG
select * from QuanLy.SANPHAM
		

/*
Module 2
Name: CheckHSD
Module type: Trigger
Puppose:  Kiểm tra mức độ đáng tin cậy của hạn sử dụng sau khi nhập 1 dòng giá trị vào bảng SanPham. 
Nếu hạn sử dụng của sản phẩm đã hết theo thông tin NSX và HSD của sản phẩm thì rollback.
Input: N/a
Output: N/a 
- Type: after
- Event: insert
- Table: SANPHAM
- Process: 1. Tim NSX và HSD trong bảng inserted -> @NSX và @HSD
			2. So sánh: Kiểm tra hạn sử dụng là ngày hay tháng
				+ Nếu tháng thì kiểm tra xem số tháng từ ngày sản xuất đến hiện tại có vượt quá số tháng của hạn sử dụng hay không?
					- Có thì rollback, không thì cho nhập bình thuờng
				+ Nếu ngày thì kiểm tra xem số ngày từ ngày sản xuất đến hiện tại có vượt quá số ngày của hạn sử dụng hay không?
					- Có thì rollnback, không thì cho nhập bình thường
*/
select * from QuanLy.SANPHAM
create or alter trigger CheckHSD
on QuanLy.SANPHAM
for insert
as
begin
	declare @ngaySanXuat date,
			@hanSuDung nvarchar(20)
	select @ngaySanXuat=NSX, @hanSuDung=HSD
	from inserted
	if @hanSuDung like N'% tháng'
	begin
		if DATEDIFF(MONTH,@ngaySanXuat,GETDATE()) > left(@hanSuDung,2)
		begin
			print N'Sản phẩm đã hết hạn sử dụng'
			rollback
		end
	end
	else
	begin
		if DATEDIFF(DAY,@ngaySanXuat,GETDATE()) > left(@hanSuDung,2)
		begin
			print N'Sản phẩm đã hết hạn sử dụng'
			rollback
		end
	end
end
insert into QuanLy.SANPHAM values('SP1099', N'Bánh mì hoa cúc','gam', N'Bánh mì', '2023-08-30', N'6 tháng', 45000)

select * from QuanLy.SANPHAM
/*
Module 3,4
Module type: Trigger
Name: CheckValidDayXK
Puppose:  Kiểm tra mức độ đáng tin cậy của ngày xuất kho/nhập kho sau khi nhập 1 dòng giá trị vào bảng PHIEUXUATKHO.
Nếu ngày xuất kho > getdate thì rollback.
Input: N/a
Output: N/a 
- Type: after
- Event: insert
- Table: PHIEUXUATKHO
- Process: 1. Tim NgayXuat trong bảng inserted -> @NgayXuat
			2. So sánh: 
				+ Nếu NgayXuat > Getdate() thì rollback
				+ Nếu không thì cho nhập bình thường
*/

create or alter trigger CheckValidDayXK
on Phieu.XUATKHO
for insert, update
as
begin
	declare @ngayXuat date
	select @ngayXuat=NgayXuat
	from inserted
	if @ngayXuat > getdate()
	begin
		print N'Ngày xuất không hợp lệ'
		rollback
	end
end
insert into Phieu.XUATKHO values('X1087', 'K791', '2024-10-23',90800, 7)


/*
Module 4
Module type: Trigger
Name: CheckValidDayNK
Puppose:  Kiểm tra mức độ đáng tin cậy của ngày xuất kho/nhập kho sau khi nhập 1 dòng giá trị vào bảng PHIEUNHAPKHO. 
Nếu ngày nhập kho > getdate thì rollback.
Input: N/a
Output: N/a 
- Type: after
- Event: insert
- Table: PHIEUNHAPKHO
- Process: 1. Tim NgayNhap trong bảng inserted -> @NgayNhap
			2. So sánh: 
				+ Nếu NgayNhap > Getdate() thì rollback
				+ Nếu không thì cho nhập bình thường
*/
create or alter trigger CheckValidDayNK
on Phieu.NHAPKHO
for insert, update
as
begin
	declare @ngayNhap date
	select @ngayNhap=NgayNhap
	from inserted
	if @ngayNhap > GETDATE()
	begin
		print N'Ngày nhập không hợp lệ'
		rollback
	end
end
insert into Phieu.NHAPKHO values('N1001','K254','2024-10-25',123000,4)
select * from Phieu.NHAPKHO




/*
Module 5,6
Module type: Trigger
Name: SwitchLydoNK
Puppose:  Vì dữ liệu là quan trọng, thay vì xóa dòng dữ liệu này, ta có thể để trạng thái của nó 
thành vô hiệu hóa để sau này phục vụ cho nhu cầu thống kê lại những dữ liệu đã bị xóa và phân tích nguyên do.
Input: N/a
Output: N/a 
- Type: instead of
- Event: delete
- Table: PHIEUNHAPKHO
- Process: 1. Cập nhật trạng thái lý do thành 9 sau đó kết thúc hành động.
*/

create or alter trigger SwitchLyDoNK
on Phieu.NHAPKHO
instead of delete
as
begin
	update Phieu.NHAPKHO
	set LyDo='9'
	where MaNhap in(select MaNhap from deleted)
end
delete from Phieu.NHAPKHO where MaNhap='N0005'




/*
Module 6
Module type: Trigger
Name: SwitchLydoXK
Puppose:  Vì dữ liệu là quan trọng, thay vì xóa dòng dữ liệu này, ta có thể để trạng thái của nó 
thành vô hiệu hóa để sau này phục vụ cho nhu cầu thống kê lại những dữ liệu đã bị xóa và phân tích nguyên do.
Input: N/a
Output: N/a 
- Type: instead of
- Event: delete
- Table: PHIEUXUATKHO
- Process: 1. Cập nhật trạng thái lý do thành 9 sau đó kết thúc hành động.
*/
create or alter trigger SwitchLyDoXK
on Phieu.XUATKHO
instead of delete
as
begin
	update Phieu.XUATKHO
	set LyDo='9'
	where MaXuat in(select MaXuat from deleted)
end
delete from Phieu.XUATKHO where MaXuat='X0005'



/*
Module 7
Module type: Triger
Name: checkValidNk
Puppose:  Kiểm tra mức độ đáng tin cậy của số lượng nhập kho sau khi nhập 1 dòng giá trị vào bảng PHIEUNHAPKHO
Nếu ngày số lượng nhập kho <=0 thì rollback.
Input: N/a
Output: N/a 
- Type: after 
- Event: insert
- Table: PHIEUNHAPKHOCT
- Process: 1. Tìm số lượng nhập kho trong bảng inserted. -> @số lượng
			2. So sánh @số lượng nhập kho <=0 thì rollback nếu không thì giữ nguyên
*/

create or alter trigger checkValidNk
on PhieuCT.NHAPKHO
for insert
as
begin
	declare @soLuong int
	select @soLuong=SoLuong
	from inserted
	if @soLuong <= 0
	begin
		print N'Số lượng không hợp lệ'
		rollback
	end
end
insert into PhieuCT.NHAPKHO values('N0501','SP0004',-9,60000,600000)
select * from QuanLy.SANPHAM
/*
Module 8
Module type: Triger
Name: checkValidXk
Puppose:  Kiểm tra mức độ đáng tin cậy của số lượng xuất kho sau khi nhập 1 dòng giá trị vào bảng PHIEUXUATKHO
Nếu ngày số lượng xuất kho <=0 thì rollback.
Input: N/a
Output: N/a 
- Type: after 
- Event: insert
- Table: PHIEUXUATKHO
- Process: 1. Tìm số lượng số lượng xuất kho trong bảng inserted. -> @số lượng
			2. So sánh @số lượng xuất kho <=0 thì rollback nếu không thì giữ nguyên
*/

create or alter trigger checkValidXK
on PhieuCT.XUATKHO
for insert
as
begin
	declare @soLuong int
	select @soLuong=SoLuong
	from inserted
	if @soLuong <= 0
	begin
		print N'Số lượng không hợp lệ'
		rollback
	end
end
insert into PhieuCT.XUATKHO values('X0500','SP0009',-9,60000,600000)

/*
Module 9 
Module type: Triger
Name: UpdateSLafterX
Puppose: Tự động cập nhật số lượng tồn kho ở bảng KHOCT sau khi xuất (Sau khi nhập 1 dòng dữ liệu tại bảo PHIEUXUATKHOCT).
Input: N/a
Output: N/a 
- Type: after 
- Event: insert
- Table: PHIEUXUATKHOCT
- Process: 1. Tìm số lượng xuat kho, Ma Xuất Kho, Mã Sản phẩm ở bảng inserted. -> @số lượng, @MaXuat, @MaSP
			2. Từ @MaXuat tìm Mã Kho ở bảng PhieuXuatKho điều kiện MaXuat = @MaXuat
			3. Cập nhật bảng KHOCT như sau: Ton Dau = TonDau - @Số lượng / Điều kiện MaKho = @MaKho và MaSP = @MaSP
*/





delete from PhieuCT.XUATKHO
where MaXuat = 'X0611'

CREATE OR ALTER TRIGGER UpdateSLafterX
ON PhieuCT.XUATKHO
AFTER INSERT
AS
BEGIN
    DECLARE @Soluong INT, @MaXuat CHAR(5), @MaSP CHAR(6), @MaKho CHAR(4);

    SELECT @Soluong = SoLuong, @MaXuat = MaXuat, @MaSP = MaSP
    FROM inserted;

    SELECT @MaKho = MaKho
    FROM Phieu.XUATKHO
    WHERE MaXuat = @MaXuat;

    UPDATE QuanLy.KHOCT
    SET TonDau = TonDau - @Soluong
    WHERE MaKho = @MaKho AND MaSP = @MaSP;
END;
insert into PhieuCT.XUATKHO values ('X0611', 'SP0227', 7,20,140)--26-7
/*
Module 10
Module type: Triger
Name: UpdateSLafterN
Puppose: Tự động cập nhật số lượng tồn kho ở bảng KHOCT sau khi Nhập (Sau khi nhập 1 dòng dữ liệu tại bảo PHIEUNHAPKHOCT).
Input: N/a
Output: N/a 
- Type: after 
- Event: insert
- Table: PHIEUNHAPKHOCT
- Process: 1. Tìm số lượng nhap kho, Ma nhập Kho, Mã Sản phẩm ở bảng inserted. -> @số lượng, @MaNhap, @MaSP
			2. Từ @MaNhap tìm Mã Kho ở bảng PhieuNhapKho điều kiện MaXuat = @MaXuat
			3. Cập nhật bảng KHOCT như sau: Ton Dau = TonDau - @Số lượng / Điều kiện MaKho = @MaKho và MaSP = @MaSP
*/
create or alter trigger UpdateSLafterN
on PhieuCT.NHAPKHO
after insert 
as 
begin
	Declare @Soluong int, @MaNhap char(5), @MaSP char(6), @MaKho char(4) 
	Select @Soluong = SoLuong, @MaNhap = MaNhap, @MaSP = MaSP
	from inserted
	select @MaKho = MaKho from Phieu.NHAPKHO where MaNhap = @MaNhap
	update QuanLy.KHOCT
	set TonDau = TonDau + @Soluong
	where MaKho = @MaKho and MaSP = @MaSP
end

select * from  Phieu.NHAPKHO --K121
Select * from QuanLy.KHOCT 
Insert into PhieuCT.NHAPKHO values  ('N0619','SP0363',8,20,160)--23+8

/*
Module 11
Module type: Trigger
Name: insertAutoPNK
Puppose: để thêm mới đầy đủ thông tin từ bảng PhieuCT.NHAPKHO do nhân viên nhập và cập nhật tổng tiền vào bảng PhieuCT.NHAPKHO
- Type: instead of (bởi vì NHANVIEN sẽ nhập vào MaNhap,MaSP,SoLuong vào bảng Phieu.NHAPKHO)
- Events: insert
- Table: PHIEUCT.NHAPKHO
- Process: 
			1. 
				1.1/. Lấy @MaNhap, @MaSP, @SoLuong tu bảng INSERTED.
				1.2/. Nếu @MaNhap không nằm trong Phieu.NHAPKHO: =>rollback
			2. Ngược lại:
				2.1/ Lấy @DonGia từ bảng QuanLy.SANPHAM dựa trên @MASP, dk @MaSP=MaSP.
				2.2/ Tính thành tiền :@ThanhTien=@DonGia*@SoLuong. 
				2.3/ Nhập dòng dữ liệu vào PhieuCT.NHAPKHO bao gồm các giá trị:[PhieuCT].[NHAPKHO]([MaNhap],[MaSP],[SoLuong],[DonGia],[ThanhTien] 
				2.4/ Tính tổng tiền của các sản phẩm có chung @MaNhap trong bảng PhieuCT.NHAPKHO.
				2.5/ Cập nhật tổng tiền vào bảng PhieuCT.NHAPKHO, dk:@MaNhap=MaNhap
*/
create or alter trigger insertAutoPNK
on [PhieuCT].[NHAPKHO]
instead of insert
as
begin
	declare @MaNhap char(5), @MaSP char(6), @SoLuong int, @DonGia float, @ThanhTien float
	select @MaNhap = MaNhap, @MaSP = MaSP, @SoLuong = SoLuong from inserted
	if @MaNhap not in (select MaNhap from Phieu.NHAPKHO)
	begin
		print ('Ma Nhap khong hop le !!')
		rollback
	end
	else
	begin
		Select @DonGia = DonGia from QuanLy.SANPHAM where MaSP = @MaSP
		set @ThanhTien = @DonGia*@SoLuong
		insert into [PhieuCT].[NHAPKHO]([MaNhap],[MaSP],[SoLuong],[DonGia],[ThanhTien])
		values (@MaNhap,@MaSP,@SoLuong,@DonGia,@ThanhTien)

		declare @TongTien float
		set @TongTien = (select Sum(ThanhTien) from [PhieuCT].[NHAPKHO] where MaNhap = @MaNhap)
		update [Phieu].[NHAPKHO]
		set TongTien = @TongTien
		where MaNhap = @MaNhap
	end
end
go 

Select * from PhieuCT.NHAPKHO
Select * from QuanLy.SANPHAM --

insert into PhieuCT.NHAPKHO([MaNhap],[MaSP],[SoLuong])
values('N0501','SP0001',3) --Don gia 22, Thanh tien 66

/*
Module 12
Module type: Trigger
Name: insertAutoPXK
Puppose: để thêm mới đầy đủ thông tin từ bảng PhieuCT.XUATKHO do nhân viên nhập và cập nhật tổng tiền và bảng PhieuCT.XUATKHO
- Type: instead of (bởi vì NHANVIEN sẽ nhập MaXuat,MaKho,NgayXuat,LyDo vào bảng Phieu.XUATKHO)
- Events: insert
- Table: PHIEUCT.XUATKHO
- Process:	1. 
				1.1/. Lấy @MaXuat, @MaSP, @SoLuong tu bảng INSERTED.
				1.2/. Nếu @MaXuat không nằm trong Phieu.XUATKHO: =>rollback
			2. Ngược lại:
				2.1/ Lấy @DonGia từ bảng QuanLy.SANPHAM dựa trên @MASP, dk @MaSP=MaSP.
				2.2/ Tính thành tiền :@ThanhTien=@DonGia*@SoLuong. 
				2.3/ Nhập dòng dữ liệu vào PhieuCT.XUATKHO bao gồm các giá trị:[PhieuCT].[XUATKHO]([MaXuat],[MaSP],[SoLuong],[DonGia],[ThanhTien]
				2.4/ Tính tổng tiền của các sản phẩm có chung @MaXuat trong bảng PhieuCT.XUATKHO.
				2.5/ Cập nhật tổng tiền vào bảng PhieuCT.XUATKHO, dk:@MaXuat=MaXuat
*/
go
create or alter trigger insertAutoPXK
on [PhieuCT].[XUATKHO]
instead of insert
as
begin
	declare @MaXuat char(5), @MaSP char(6), @SoLuong int, @DonGia float, @ThanhTien float
	select @MaXuat = MaXuat, @MaSP = MaSP, @SoLuong = SoLuong from inserted
	If @MaXuat not in (select MaXuat from Phieu.XUATKHO)
	begin 
		print('Ma Xuat Khong hop le')
	end
	else
	begin
		Select @DonGia = DonGia from QuanLy.SANPHAM where MaSP = @MaSP
		set @ThanhTien = @DonGia*@SoLuong
		insert into [PhieuCT].[XUATKHO]([MaXuat],[MaSP],[SoLuong],[DonGia],[ThanhTien])
		values (@MaXuat,@MaSP,@SoLuong,@DonGia,@ThanhTien)
		
		declare @TongTien float
		set @TongTien = (select Sum(ThanhTien) from [PhieuCT].[XUATKHO] where MaXuat = @MaXuat)
		update [Phieu].[XUATKHO]
		set TongTien = @TongTien
		where MaXuat = @MaXuat
	end
end
/*
Module 13
Module type: Trigger
Name: insertAutoPGH
Puppose: để thêm mới đầy đủ thông tin từ bảng PhieuCT.GIAOHANG do nhân viên nhập và cập nhật tổng tiền vào bảng PhieuCT.GIAOHANG
- Type: instead of (bởi vì NHANVIEN sẽ nhập MaGH,MaNCC,NgayGiao, VAT, HinhThucTT vào bảng Phieu.GIAOHANG
- Events: insert
- Table: PHIEUCT.XUATKHO
- Process:	1. 
				1.1/. Lấy @MaGH, @MaSP, @SoLuongCT, @SoLuongT tu bảng INSERTED.
				1.2/. Nếu @MaGH không nằm trong Phieu.GIAOHANG: =>rollback
			2. Ngược lại:
				2.1/ Lấy @DonGia từ bảng QuanLy.SANPHAM dựa trên @MASP, dk @MaSP=MaSP.
				2.2/ Tính thành tiền :@ThanhTien=@DonGia*@SoLuongT. 
				2.3/ Nhập dòng dữ liệu vào PhieuCT.GIAOHANG bao gồm các giá trị:[PhieuCT].[GIAOHANG]([MaGH],[MaSP],[SoLuongCT],[SoLuongT],[DonGia],[ThanhTien]
				2.4/ Tính tổng tiền của các sản phẩm có chung @MaGH trong bảng PhieuCT.GIAOHANG.
				2.5/ Cập nhật tổng tiền vào bảng PhieuCT.GIAOHANG, dk:@MaGH=MaGH
*/
go
create or alter trigger insertAutoPGH
on [PhieuCT].[GIAOHANG]
instead of insert
as
begin
	declare @MaGH char(5), @MaSP char(6), @SoLuongCT int, @SoLuongT int, @DonGia float, @ThanhTien float
	select @MaGH = MaGH, @MaSP = MaSP, @SoLuongCT = SoLuongCT, @SoLuongT = SoLuongT from inserted
	If @MaGH not in (select MaGH from Phieu.GIAOHANG)
	begin 
		print('Ma GIAO HANG Khong hop le')
	end
	else
	begin
		Select @DonGia = DonGia from QuanLy.SANPHAM where MaSP = @MaSP
		set @ThanhTien = @DonGia*@SoLuongT
		insert into [PhieuCT].[GIAOHANG]([MaGH],[MaSP],[SoLuongCT],[SoLuongT],[DonGia],[ThanhTien])
		values (@MaGH,@MaSP,@SoLuongCT,@SoLuongT,@DonGia,@ThanhTien)

		declare @TongTien float
		set @TongTien = (select Sum(ThanhTien) from [PhieuCT].[GIAOHANG] where MaGH = @MaGH)
		update [Phieu].[GIAOHANG]
		set TongTien = @TongTien
		where MaGH = @MaGH
	end
end


-------------------------------------TRIGER END---------------------------------

------------------------------------START PROC----------------------------------
/*
Module 1
Module type: proceduce
Name: Cập nhật tiền hàng của bảng PHIEUGIAOHANG
Input: @MaGH
Output: N/a
Process: 1. Cho chạy hàm getTongtienGH() mà dữ liệu đầu vào là @MaGH => lưu vào biến tổng tiền
		2. Cập nhật bảng PHIEUGIAOHANG set TongTien = @TongTien điều kiện: MaGH = @MaGH
*/

create or alter proc TongTienGH(@MaGH char(4))
as
begin
	declare @TongTien int
	set @TongTien = dbo.getTongtienGH(@MaGH)
	update Phieu.GIAOHANG
	set TongTien = @TongTien
	where MaGH = @MaGH
	print 'Cap nhat Thanh Cong'
end

select * from Phieu.GIAOHANG
exec TongTienGH 'G001'

/*
Module 2
Module type: proceduce
Name: Cập nhật tiền hàng của bảng PHIEUNHAPKHO
Input: @MaNhap 
Output: N/a
Process: 1. Cho chạy hàm getTongtienNK() mà dữ liệu đầu vào là @MaNK => lưu vào biến tổng tiền
		2. Cập nhật bảng PHIEUNHAPKHO set TongTien = @TongTien điều kiện: MaNhap = @MaNhap
*/
Create or alter proc TongTienNK(@MaNK char(5))
as
begin
	declare @TongTien int
	set @TongTien = dbo.getTongtienNK(@MaNK)
	update Phieu.NHAPKHO
	set TongTien = @TongTien
	where MaNhap = @MaNK
	print 'Thanh Cong'
end
select dbo.getTongtienNK('N0001')
exec TongTienNK 'N0002'
select * from Phieu.NHAPKHO


/*
Module 3
Module type: proceduce
Name: Cập nhật tiền hàng của bảng PHIEUXUATKHO
Input: @MaXuat
Output: N/a
Process: 1. Cho chạy hàm getTongtienXK() mà dữ liệu đầu vào là @MaXK => lưu vào biến tổng tiền
		2. Cập nhật bảng PHIEUXUATKHO set TongTien = @TongTien điều kiện: MaXuat = @MaXuat
*/
Create or alter proc TongTienXK(@MaXK char(5))
as
begin
	declare @TongTien int
	set @TongTien = dbo.getTongtienXK(@MaXK)
	update Phieu.XUATKHO
	set TongTien = @TongTien
	where MaXuat = @MaXK
	print 'Thanh Cong'
end

exec TongTienXK 'X0002'
select * from Phieu.XUATKHO


