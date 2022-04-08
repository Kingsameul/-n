USE master
go
if (exists(SELECT * FROM sysdatabases where name=N'Thulan1'))
	drop database Thulan1
go
CREATE DATABASE Thulan1
go
USE Thulan1
GO

-- tao bang Thu tien phat
CREATE TABLE Thu_tien_phat
( MaPhat CHAR(5),
	MaKh CHAR(6),
	Li_do_vi_pham NVARCHAR(40),
	Tien_phat MONEY,
	So_Tien_da_thu MONEY,
	So_tien_con_no MONEY,
    Ngay_thu date
	CONSTRAINT PK_MaPhat 
PRIMARY KEY (MaPhat))
GO
--Tinh trang sach
CREATE TABLE Tinh_trang_sach
(		Ma_Tinh_trang NVARCHAR(20),
		Tinh_trang NVARCHAR(40)
		CONSTRAINT PK_TinhTrang
		PRIMARY KEY (Ma_Tinh_trang))
		go
	-- tao bang sach
CREATE TABLE SACH
	(
	MaSach CHAR(8) UNIQUE NOT NULL,
	TenS NVARCHAR(50) NOT null,
	MaTL CHAR(10) ,
	MaTG CHAR(4),
	Namxb CHAR(4) ,
	Gia MONEY Check(Gia between 0 and 2000000),
	MaNXB NCHAR(5) not NULL,
	Ma_Tinh_trang NVARCHAR(20)
	 CONSTRAINT PK_MaSach 
 PRIMARY KEY (MaSach))
 go
 --tao bang khach hang 
CREATE TABLE TheKH
 (
	 MaKh CHAR(6) unique NOT NULL,
	 HoTen NVARCHAR(40) NOT NULL,
	 DChi NVARCHAR(40),
	 SDT varCHAR(11),
	 NgSinh DATE CHECK(YEAR(CURRENT_TIMESTAMP)-YEAR(NgSinh)>=12),
	 NgDK DATE,
	 HanThe DATE,
	 Tinh_trang_the NVARCHAR(50),
	 So_sach_dang_muon INT,
	Tong_no MONEY,
	So_lan_vi_pham int
 CONSTRAINT PK_TheKH
 PRIMARY KEY (MaKh))
 go
 --tao bang Phieu mượn
 CREATE TABLE Phieu_muon
 (
	 MaPhieu_muon VARCHAR(9) UNIQUE NOT NULL,
	 MaKh CHAR(6),
	  Ngaymuon DATE,
	 SL_sach_muon int
 CONSTRAINT PK_PhieuMuon 
 PRIMARY KEY (MaPhieu_muon))
 go
 --tao bang Chi Tiết Phiếu mượn
 CREATE TABLE CT_PhieuMuon
 (
	  MaPhieu_muon VARCHAR(9),	
	 MaSach CHAR(8),
	 Hantra DATE,
	 Tinh_trang_muon NVARCHAR(20)
 
 CONSTRAINT PK_CTPhieuMuon primary key(MaPhieu_muon,MaSach))
 go
 --tao bang the loai
 CREATE TABLE TheLoai
 (
     MaTL CHAR(10) UNIQUE NOT NULL,
	 TenTLoai NVARCHAR(30),
CONSTRAINT PK_TL PRIMARY KEY(MaTL))
go
--tao bang tac gia
CREATE TABLE TacGia
(	MaTG CHAR(4),
	TenTG NVARCHAR(40) UNIQUE not null,
	Namsinh CHAR(4),
	Nammat NvarCHAR(4) NOT NULL DEFAULT(N'sống'),
	Quoctich NVARCHAR(40) 
	CONSTRAINT PK_TenTG 
 PRIMARY KEY (MaTG))
 GO

-- tao bang NXB
CREATE TABLE NXB
	( 
	MaNXB NCHAR(5) UNIQUE not null,
	TenNXB NVARCHAR(100),
	So_luong_sach_XB INT
	CONSTRAINT PK_MaNXB
 PRIMARY KEY (MaNXB))
 go
 -- Tong ket Muon sach 
 CREATE TABLE TK_MuonSach
 (	MaTK CHAR(5),
	Tong_so_lan_muon INT,
	Ti_le FLOAT 
	CONSTRAINT PK_TK_MUONSACH
	PRIMARY KEY (MaTK))
	go
-- Chi Tiet Tong ket Muon sach 
CREATE TABLE CTTK_MuonSach
(	MaTK CHAR(5),
	MaSach CHAR(8),
	So_lan_muon_theo_tung_quyen INT
	CONSTRAINT PK_CTTK_MUONSACH
	PRIMARY KEY (MaTK,MaSach))
	GO
 -- Phieu tra sach
 CREATE TABLE PhieuTra
 (  MaPhieu_muon VARCHAR(9),
 	 MaSach CHAR(8),
	NgayTra DATE,
	SoNgayMuon INT,
	TienPhat MONEY,
	Tinh_trang_tra_sach NVARCHAR(40),
	Ghi_chu NVARCHAR(100)
	CONSTRAINT PK_PhieuTra
	PRIMARY KEY (MaPhieu_muon,MaSach))
	go


------
-------
-----------------------------
----------------------------------------------
--Khoa ngoai cho Bang TKMUONSACH
ALTER TABLE dbo.CTTK_MuonSach ADD CONSTRAINT FK_TKCTMUONSACH FOREIGN KEY (MaTK) REFERENCES dbo.TK_MuonSach(MaTK)
GO
ALTER TABLE dbo.CTTK_MuonSach ADD CONSTRAINT FK_TKCTMUONSACH2 FOREIGN KEY(MaSach) REFERENCES dbo.SACH(MaSach)
GO
--Khoa ngoai cho Sach
ALTER TABLE dbo.SACH ADD CONSTRAINT FK1_SAch FOREIGN KEY (MaTL) REFERENCES dbo.TheLoai(MaTL)
GO
ALTER TABLE dbo.SACH ADD CONSTRAINT FK2_Sach FOREIGN KEY (MaNXB) REFERENCES dbo.NXB(MaNXB)
GO
ALTER TABLE dbo.SACH ADD CONSTRAINT FK3_SAch FOREIGN KEY (MaTG) REFERENCES dbo.TacGia(MaTG)
GO
ALTER TABLE dbo.SACH ADD CONSTRAINT FK4_SAch FOREIGN KEY (Ma_Tinh_trang) REFERENCES dbo.Tinh_trang_sach(Ma_Tinh_trang)
GO
-- Khóa ngoại chi tiết phiếu mượn
ALTER TABLE dbo.CT_PhieuMuon ADD CONSTRAINT FK1_CTPM FOREIGN KEY (MaPhieu_muon) REFERENCES dbo.Phieu_muon(MaPhieu_muon)
go
ALTER TABLE dbo.CT_PhieuMuon ADD CONSTRAINT FK2_CTPM FOREIGN KEY (MaSach) REFERENCES dbo.SACH(MaSach)
GO
--Khoa ngoại cho Phiếu mượn
ALTER TABLE dbo.Phieu_muon ADD CONSTRAINT FK1_PM FOREIGN KEY (MaKh) REFERENCES dbo.TheKH(MaKh)
go

--Khoa ngoai cho phieu tra sach
ALTER TABLE dbo.PhieuTra ADD CONSTRAINT FK1_Tra FOREIGN KEY (MaPhieu_muon,MaSach) REFERENCES dbo.CT_PhieuMuon(MaPhieu_muon,MaSach)
GO

--khoa ngoai cho Phat
ALTER TABLE dbo.Thu_tien_phat ADD CONSTRAINT FK1_Phat1 FOREIGN KEY (MaKh) REFERENCES dbo.TheKH(MaKh)
GO



INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK01 ', 1, 2.4390243902439024)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK02 ', 2, 4.8780487804878048)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK03 ', 2, 4.8780487804878048)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK04 ', 2, 4.8780487804878048)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK05 ', 1, 2.4390243902439024)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK06 ', 1, 2.4390243902439024)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK07 ', 3, 7.3170731707317067)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK08 ', 2, 4.8780487804878048)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK09 ', 1, 2.4390243902439024)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK10 ', 1, 2.4390243902439024)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK11 ', 2, 4.8780487804878048)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK12 ', 1, 2.4390243902439024)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK13 ', 1, 2.4390243902439024)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK14 ', 1, 2.4390243902439024)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK15 ', 1, 2.4390243902439024)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK16 ', 2, 4.8780487804878048)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK17 ', 3, 7.3170731707317067)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK18 ', 3, 7.3170731707317067)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK19 ', 1, 2.4390243902439024)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK20 ', 1, 2.4390243902439024)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK21 ', 1, 2.4390243902439024)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK22 ', 2, 4.8780487804878048)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK23 ', 1, 2.4390243902439024)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK24 ', 1, 2.4390243902439024)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK25 ', 1, 2.4390243902439024)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK26 ', 2, 4.8780487804878048)
INSERT [dbo].[TK_MuonSach] ([MaTK], [Tong_so_lan_muon], [Ti_le]) VALUES (N'TK27 ', 1, 2.4390243902439024)
GO
INSERT [dbo].[Tinh_trang_sach] ([Ma_Tinh_trang], [Tinh_trang]) VALUES (N'TT001', N'Có sẵn')
INSERT [dbo].[Tinh_trang_sach] ([Ma_Tinh_trang], [Tinh_trang]) VALUES (N'TT002', N'Đang mượn')
INSERT [dbo].[Tinh_trang_sach] ([Ma_Tinh_trang], [Tinh_trang]) VALUES (N'TT003', N'Hỏng')
INSERT [dbo].[Tinh_trang_sach] ([Ma_Tinh_trang], [Tinh_trang]) VALUES (N'TT004', N'Mất')
GO
INSERT [dbo].[TheLoai] ([MaTL], [TenTLoai]) VALUES (N'321465754 ', N'Văn học Việt Nam')
INSERT [dbo].[TheLoai] ([MaTL], [TenTLoai]) VALUES (N'321787897 ', N'Văn học nước ngoài')
INSERT [dbo].[TheLoai] ([MaTL], [TenTLoai]) VALUES (N'325465788 ', N'Y học')
INSERT [dbo].[TheLoai] ([MaTL], [TenTLoai]) VALUES (N'576878456 ', N'Tâm lí')
INSERT [dbo].[TheLoai] ([MaTL], [TenTLoai]) VALUES (N'65436565  ', N'Kinh tế học')
INSERT [dbo].[TheLoai] ([MaTL], [TenTLoai]) VALUES (N'67865456  ', N'Từ điển')
INSERT [dbo].[TheLoai] ([MaTL], [TenTLoai]) VALUES (N'689986547 ', N'Tiểu thuyết')
INSERT [dbo].[TheLoai] ([MaTL], [TenTLoai]) VALUES (N'786452468 ', N'Truyện tranh')
INSERT [dbo].[TheLoai] ([MaTL], [TenTLoai]) VALUES (N'809854357 ', N'SGK')
INSERT [dbo].[TheLoai] ([MaTL], [TenTLoai]) VALUES (N'868302222 ', N'Tản văn')
GO
INSERT [dbo].[NXB] ([MaNXB], [TenNXB], [So_luong_sach_XB]) VALUES (N'BFB  ', N'Forgotten Book', 2)
INSERT [dbo].[NXB] ([MaNXB], [TenNXB], [So_luong_sach_XB]) VALUES (N'BO   ', N'Nhà xuất bản Oxford', 2)
INSERT [dbo].[NXB] ([MaNXB], [TenNXB], [So_luong_sach_XB]) VALUES (N'VNDT ', N'Nhà xuất bản Dân trí', 1)
INSERT [dbo].[NXB] ([MaNXB], [TenNXB], [So_luong_sach_XB]) VALUES (N'VNGD ', N'Nhà xuất bản Giáo dục Việt Nam', 5)
INSERT [dbo].[NXB] ([MaNXB], [TenNXB], [So_luong_sach_XB]) VALUES (N'VNHĐ ', N'Nhà xuất bản Hồng Đức', 4)
INSERT [dbo].[NXB] ([MaNXB], [TenNXB], [So_luong_sach_XB]) VALUES (N'VNHNV', N'Nhà xuất bản Hội Nhà Văn', 1)
INSERT [dbo].[NXB] ([MaNXB], [TenNXB], [So_luong_sach_XB]) VALUES (N'VNKĐ ', N'Nhà xuất bản Kim Đồng', 35)
INSERT [dbo].[NXB] ([MaNXB], [TenNXB], [So_luong_sach_XB]) VALUES (N'VNLĐ ', N'Nhà xuất bản Lao động', 2)
INSERT [dbo].[NXB] ([MaNXB], [TenNXB], [So_luong_sach_XB]) VALUES (N'VNT  ', N'Nhà xuất bản trẻ', 12)
INSERT [dbo].[NXB] ([MaNXB], [TenNXB], [So_luong_sach_XB]) VALUES (N'VNTH ', N'Nhà xuất bản Thái Hà', 2)
INSERT [dbo].[NXB] ([MaNXB], [TenNXB], [So_luong_sach_XB]) VALUES (N'VNVH ', N'Nhà xuất bản văn học', 19)
INSERT [dbo].[NXB] ([MaNXB], [TenNXB], [So_luong_sach_XB]) VALUES (N'VNYH ', N'Nhà xuất bản Y học', 2)
GO
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'NTG ', N'Nhiều tác giả', N'    ', N'', N'')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T001', N'Kazuo Ishiguro', N'1954', N'sống', N'Anh')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T002', N'Dale Carnegie', N'1888', N'1955', N'Mỹ')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T003', N'Ayn Rand', N'1905', N'1982', N'Mỹ')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T004', N'Kalanithi', N'1977', N'2015', N'Mỹ')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T005', N'Napoleon Hill', N'1883', N'1970', N'Mỹ')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T006', N'Frank H.Netter', N'1906', N'1991', N'Mỹ')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T007', N'Benjamin Graham', N'1894', N'1976', N'Mỹ')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T008', N'Nguyễn Ngọc Tư', N'1976', N'sống', N'Việt Nam')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T009', N'Pasternak', N'1890', N'1960', N'Nga')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T010', N'Akira Toriyama', N'1955', N'sống', N'Nhật Bản')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T011', N'Fujiko F.Fujio', N'1933', N'1996', N'Nhật Bản')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T012', N'Eiichiro Oda', N'1975', N'sống', N'Nhật Bản')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T013', N'Takehiko Inoue', N'1967', N'sống', N'Nhật Bản')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T014', N'Gustave Le Bon', N'1841', N'1931', N'Pháp')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T015', N'Ngô Thừa Ân', N'1506', N'1581', N'Trung Quốc')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T016', N'Trác Nhã', N'1993', N'sống', N'Trung Quốc')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T017', N'La Quán Trung', N'1328', N'1398', N'Trung Quốc')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T018', N'Đinh Mặc', N'1983', N'sống', N'Trung Quốc')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T019', N'Cố Mạn', N'1981', N'sống', N'Trung Quốc')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T020', N'Nguyễn Ngọc Ký', N'1947', N'sống', N'Việt Nam')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T021', N'Ngô Tất Tố', N'1894', N'1954', N'Việt Nam')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T022', N'Tô Hoài', N'1920', N'2014', N'Việt Nam')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T023', N'Nguyễn Du', N'1765', N'1820', N'Việt Nam')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T024', N'Nam Cao', N'1915', N'1951', N'Việt Nam')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T025', N'Phạm Lữ Ân', N'2000', N'sống', N'Việt Nam')
INSERT [dbo].[TacGia] ([MaTG], [TenTG], [Namsinh], [Nammat], [Quoctich]) VALUES (N'T026', N'Khải Đơn', N'1989', N'sống', N'Việt Nam')
GO
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'BSZ01   ', N'Bác Sĩ Zhivago', N'321787897 ', N'T009', N'1988', 176000.0000, N'VNVH ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'CDMX01  ', N'Cảnh Đồi Mờ Xám', N'689986547 ', N'T001', N'1934', 98000.0000, N'VNVH ', N'TT003')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'CP01    ', N'Chí phèo', N'321465754 ', N'T024', N'1941', 120000.0000, N'VNVH ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'CP02    ', N'Chí phèo', N'321465754 ', N'T024', N'1941', 120000.0000, N'VNVH ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'D01     ', N'Doraemon', N'786452468 ', N'T011', N'1969', 22000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'D02     ', N'Doraemon', N'786452468 ', N'T011', N'1969', 22000.0000, N'VNKĐ ', N'TT003')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'D03     ', N'Doraemon', N'786452468 ', N'T011', N'1969', 22000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'D04     ', N'Doraemon', N'786452468 ', N'T011', N'1969', 22000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'D05     ', N'Doraemon', N'786452468 ', N'T011', N'1969', 22000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'D06     ', N'Doraemon', N'786452468 ', N'T011', N'1969', 22000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'D07     ', N'Doraemon', N'786452468 ', N'T011', N'1969', 22000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'D08     ', N'Doraemon', N'786452468 ', N'T011', N'1969', 22000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'D09     ', N'Doraemon', N'786452468 ', N'T011', N'1969', 22000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'D10     ', N'Doraemon', N'786452468 ', N'T011', N'1969', 22000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'D11     ', N'Doraemon', N'786452468 ', N'T011', N'1969', 22000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'D12     ', N'Doraemon', N'786452468 ', N'T011', N'1969', 22000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DB01    ', N'Dragon Ball', N'786452468 ', N'T010', N'1984', 20000.0000, N'VNKĐ ', N'TT003')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DB02    ', N'Dragon Ball', N'786452468 ', N'T010', N'1984', 20000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DB03    ', N'Dragon Ball', N'786452468 ', N'T010', N'1984', 20000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DB04    ', N'Dragon Ball', N'786452468 ', N'T010', N'1984', 20000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DB05    ', N'Dragon Ball', N'786452468 ', N'T010', N'1984', 20000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DB06    ', N'Dragon Ball', N'786452468 ', N'T010', N'1984', 20000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DB07    ', N'Dragon Ball', N'786452468 ', N'T010', N'1984', 20000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DB08    ', N'Dragon Ball', N'786452468 ', N'T010', N'1984', 20000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DB09    ', N'Dragon Ball', N'786452468 ', N'T010', N'1984', 20000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DB10    ', N'Dragon Ball', N'786452468 ', N'T010', N'1984', 20000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DB11    ', N'Dragon Ball', N'786452468 ', N'T010', N'1984', 20000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DMPLK01 ', N'Dế Mèn phiêu lưu ký', N'321465754 ', N'T022', N'1941', 250000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DMPLK02 ', N'Dế Mèn phiêu lưu ký', N'321465754 ', N'T022', N'1941', 250000.0000, N'VNKĐ ', N'TT003')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DNT01   ', N'Đắc Nhân Tâm', N'576878456 ', N'T002', N'1936', 280000.0000, N'VNT  ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DNT02   ', N'Đắc Nhân Tâm', N'576878456 ', N'T002', N'1936', 280000.0000, N'VNT  ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DNT03   ', N'Đắc Nhân Tâm', N'576878456 ', N'T002', N'1936', 280000.0000, N'VNT  ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DNT04   ', N'Đắc Nhân Tâm', N'576878456 ', N'T002', N'1936', 280000.0000, N'VNT  ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DNT05   ', N'Đắc Nhân Tâm', N'576878456 ', N'T002', N'1936', 280000.0000, N'VNT  ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DNT06   ', N'Đắc Nhân Tâm', N'576878456 ', N'T002', N'1936', 280000.0000, N'VNT  ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DNT07   ', N'Đắc Nhân Tâm', N'576878456 ', N'T002', N'1936', 280000.0000, N'VNT  ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DTL01   ', N'Đong tấm lòng', N'868302222 ', N'T008', N'1994', 68000.0000, N'VNT  ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DTL02   ', N'Đong tấm lòng', N'868302222 ', N'T008', N'1994', 68000.0000, N'VNT  ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'DTNC01  ', N'Đừng tháo xuống nụ cười', N'868302222 ', N'T026', N'2008', 96000.0000, N'VNLĐ ', N'TT004')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'GPN01   ', N'Atlas Giải Phẫu Người', N'325465788 ', N'T006', N'2016', 650000.0000, N'VNYH ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'GPN02   ', N'Atlas Giải Phẫu Người', N'325465788 ', N'T006', N'2016', 650000.0000, N'VNYH ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'HNM01   ', N'Hãy nhắm mắt khi anh đến', N'689986547 ', N'T018', N'2001', 350000.0000, N'VNVH ', N'TT002')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'HNM02   ', N'Hãy nhắm mắt khi anh đến', N'689986547 ', N'T018', N'2001', 350000.0000, N'VNVH ', N'TT002')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'HTTK01  ', N'Khi Hơi Thở Hóa Thinh Không', N'325465788 ', N'T004', N'2000', 158000.0000, N'VNLĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'KAKN01  ', N'Khéo ăn khéo nói sẽ có được thiên hạ', N'576878456 ', N'T016', N'2018', 125000.0000, N'VNVH ', N'TT004')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'KAKN02  ', N'Khéo ăn khéo nói sẽ có được thiên hạ', N'576878456 ', N'T016', N'2018', 125000.0000, N'VNVH ', N'TT002')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'NCT01   ', N'Những cây thuốc và vị thuốc Việt Nam', N'325465788 ', N'NTG ', N'1962', 89000.0000, N'VNHĐ ', N'TT004')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'NDT01   ', N'Nhà đầu tư thông minh', N'65436565  ', N'T007', N'1949', 214000.0000, N'VNDT ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'OP01    ', N'One piece', N'786452468 ', N'T012', N'1997', 26000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'OP02    ', N'One piece', N'786452468 ', N'T012', N'1997', 26000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'OP03    ', N'One piece', N'786452468 ', N'T012', N'1997', 26000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'OP04    ', N'One piece', N'786452468 ', N'T012', N'1997', 26000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'OP05    ', N'One piece', N'786452468 ', N'T012', N'1997', 26000.0000, N'VNKĐ ', N'TT002')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'OP06    ', N'One piece', N'786452468 ', N'T012', N'1997', 26000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'OP07    ', N'One piece', N'786452468 ', N'T012', N'1997', 26000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'SD01    ', N'Slam Dunk', N'786452468 ', N'T013', N'1990', 45000.0000, N'VNKĐ ', N'TT002')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'SD02    ', N'Slam Dunk', N'786452468 ', N'T013', N'1990', 45000.0000, N'VNKĐ ', N'TT002')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'SD03    ', N'Slam Dunk', N'786452468 ', N'T013', N'1990', 45000.0000, N'VNKĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'SN01    ', N'Suối nguồn', N'321787897 ', N'T003', N'1943', 198000.0000, N'VNT  ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'SNLG01  ', N'Suy nghĩ và làm giàu', N'65436565  ', N'T005', N'1940', 265000.0000, N'VNTH ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'SNLG02  ', N'Suy nghĩ và làm giàu', N'65436565  ', N'T005', N'1940', 265000.0000, N'VNTH ', N'TT004')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'T801    ', N'Toán lớp 8', N'809854357 ', N'NTG ', N'1990', 7000.0000, N'VNGD ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'T802    ', N'Toán lớp 8', N'809854357 ', N'NTG ', N'1990', 7000.0000, N'VNGD ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'T803    ', N'Toán lớp 8', N'809854357 ', N'NTG ', N'1990', 7000.0000, N'VNGD ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TA1201  ', N'Tiếng anh 12', N'809854357 ', N'NTG ', N'1990', 12000.0000, N'VNGD ', N'TT003')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TA1202  ', N'Tiếng anh 12', N'809854357 ', N'NTG ', N'1990', 12000.0000, N'VNGD ', N'TT004')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TD01    ', N'Tắt đèn', N'321465754 ', N'T021', N'1937', 125000.0000, N'VNVH ', N'TT004')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TD02    ', N'Tắt đèn', N'321465754 ', N'T021', N'1937', 125000.0000, N'VNVH ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TDH01   ', N'Tôi đi học', N'321465754 ', N'T020', N'1993', 75000.0000, N'VNT  ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TDH02   ', N'Tôi đi học', N'321465754 ', N'T020', N'1993', 75000.0000, N'VNT  ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TDK01   ', N'Tây Du Kí', N'321787897 ', N'T015', N'1986', 500000.0000, N'VNVH ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TDK02   ', N'Tây Du Kí', N'321787897 ', N'T015', N'1986', 500000.0000, N'VNVH ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TDK03   ', N'Tây Du Kí', N'321787897 ', N'T015', N'1986', 500000.0000, N'VNVH ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TDK04   ', N'Tây Du Kí', N'321787897 ', N'T015', N'1986', 500000.0000, N'VNVH ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TDTA01  ', N'Từ điển tiếng Anh Oxford', N'67865456  ', N'NTG ', N'1884', 234000.0000, N'BO   ', N'TT002')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TDTA02  ', N'Từ điển tiếng Anh Oxford', N'67865456  ', N'NTG ', N'1884', 234000.0000, N'BO   ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TDTV01  ', N'Từ điển Tiếng Việt', N'67865456  ', N'NTG ', N'1988', 198000.0000, N'VNHĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TDTV02  ', N'Từ điển Tiếng Việt', N'67865456  ', N'NTG ', N'1988', 198000.0000, N'VNHĐ ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TDTV03  ', N'Từ điển Tiếng Việt', N'67865456  ', N'NTG ', N'1988', 198000.0000, N'VNHĐ ', N'TT002')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TK01    ', N'Truyện Kiều', N'321465754 ', N'T023', N'1820', 245000.0000, N'VNVH ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TK02    ', N'Truyện Kiều', N'321465754 ', N'T023', N'1820', 245000.0000, N'VNVH ', N'TT001')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TNHH01  ', N'Nếu biết trăm năm là hữu hạn', N'868302222 ', N'T025', N'2004', 145000.0000, N'VNHNV', N'TT003')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TPOS01  ', N'The Psychology of Socialism', N'576878456 ', N'T014', N'1898', 361000.0000, N'BFB  ', N'TT003')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TPOS02  ', N'The Psychology of Socialism', N'576878456 ', N'T014', N'1898', 361000.0000, N'BFB  ', N'TT002')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'TQDN01  ', N'Tam Quốc diễn nghĩa', N'321787897 ', N'T017', N'1995', 267000.0000, N'VNVH ', N'TT002')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'YE01    ', N'Yêu em từ cái nhìn đầu tiên', N'321787897 ', N'T019', N'2006', 168000.0000, N'VNVH ', N'TT002')
INSERT [dbo].[SACH] ([MaSach], [TenS], [MaTL], [MaTG], [Namxb], [Gia], [MaNXB], [Ma_Tinh_trang]) VALUES (N'YE02    ', N'Yêu em từ cái nhìn đầu tiên', N'321787897 ', N'T019', N'2006', 168000.0000, N'VNVH ', N'TT001')
GO
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK01 ', N'TD01    ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK02 ', N'DMPLK01 ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK02 ', N'DMPLK02 ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK03 ', N'DB01    ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK03 ', N'DB02    ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK04 ', N'KAKN01  ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK04 ', N'KAKN02  ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK05 ', N'SN01    ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK06 ', N'CDMX01  ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK07 ', N'SD01    ', 2)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK07 ', N'SD02    ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK08 ', N'TPOS01  ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK08 ', N'TPOS02  ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK09 ', N'YE01    ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK10 ', N'TDTA01  ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK11 ', N'SNLG01  ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK11 ', N'SNLG02  ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK12 ', N'NDT01   ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK13 ', N'HTTK01  ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK14 ', N'NCT01   ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK15 ', N'BSZ01   ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK16 ', N'TA1201  ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK16 ', N'TA1202  ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK17 ', N'OP05    ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK17 ', N'OP06    ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK17 ', N'OP07    ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK18 ', N'D02     ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK18 ', N'D04     ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK18 ', N'D12     ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK19 ', N'DNT02   ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK20 ', N'TDK01   ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK21 ', N'TQDN01  ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK22 ', N'TDTV02  ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK22 ', N'TDTV03  ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK23 ', N'TNHH01  ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK24 ', N'DTL01   ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK25 ', N'DTNC01  ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK26 ', N'HNM01   ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK26 ', N'HNM02   ', 1)
INSERT [dbo].[CTTK_MuonSach] ([MaTK], [MaSach], [So_lan_muon_theo_tung_quyen]) VALUES (N'TK27 ', N'GPN02   ', 1)
GO
INSERT [dbo].[TheKH] ([MaKh], [HoTen], [DChi], [SDT], [NgSinh], [NgDK], [HanThe], [Tinh_trang_the], [So_sach_dang_muon], [Tong_no], [So_lan_vi_pham]) VALUES (N'13465 ', N'La Chí Tường', N'05 Lê Anh Xuân Q1 TPHCM', N'0972645203', CAST(N'2000-03-14' AS Date), CAST(N'2021-02-15' AS Date), CAST(N'2024-02-15' AS Date), N'Đang hoạt động', 1, 0.0000, 0)
INSERT [dbo].[TheKH] ([MaKh], [HoTen], [DChi], [SDT], [NgSinh], [NgDK], [HanThe], [Tinh_trang_the], [So_sach_dang_muon], [Tong_no], [So_lan_vi_pham]) VALUES (N'21748 ', N'Nguyễn Vân Anh', N'06 Lý Thường Kiệt P14 Q10 TPHCM', N'0938333989', CAST(N'1999-06-19' AS Date), CAST(N'2019-01-16' AS Date), CAST(N'2022-01-16' AS Date), N'Đang hoạt động', 0, 0.0000, 2)
INSERT [dbo].[TheKH] ([MaKh], [HoTen], [DChi], [SDT], [NgSinh], [NgDK], [HanThe], [Tinh_trang_the], [So_sach_dang_muon], [Tong_no], [So_lan_vi_pham]) VALUES (N'23975 ', N'Nguyễn Xuân Mai', N'125/23 Lý Thái Tổ Q1 TPHCM', N'0878239195', CAST(N'2001-08-09' AS Date), CAST(N'2018-04-13' AS Date), CAST(N'2021-04-13' AS Date), N'Không hoạt động ', 0, 0.0000, 0)
INSERT [dbo].[TheKH] ([MaKh], [HoTen], [DChi], [SDT], [NgSinh], [NgDK], [HanThe], [Tinh_trang_the], [So_sach_dang_muon], [Tong_no], [So_lan_vi_pham]) VALUES (N'27492 ', N'Trương Vĩnh Khoa', N'973 Trần Văn Đang P8 Q3 TPHCM', N'0339860459', CAST(N'2007-04-26' AS Date), CAST(N'2019-10-27' AS Date), CAST(N'2022-10-27' AS Date), N'Đang hoạt động', 1, 0.0000, 0)
INSERT [dbo].[TheKH] ([MaKh], [HoTen], [DChi], [SDT], [NgSinh], [NgDK], [HanThe], [Tinh_trang_the], [So_sach_dang_muon], [Tong_no], [So_lan_vi_pham]) VALUES (N'35866 ', N'Trần Thái Bảo', N'05 Nguyễn Viết Xuân Q1 TPHCM', N'0947294637', CAST(N'1992-11-12' AS Date), CAST(N'2019-08-20' AS Date), CAST(N'2022-08-20' AS Date), N'Đang hoạt động', 0, 152500.0000, 4)
INSERT [dbo].[TheKH] ([MaKh], [HoTen], [DChi], [SDT], [NgSinh], [NgDK], [HanThe], [Tinh_trang_the], [So_sach_dang_muon], [Tong_no], [So_lan_vi_pham]) VALUES (N'38592 ', N'Phạm Minh Hoàng', N'196/28 Võ Văn Kiệt P10 Q5 TPHCM', N'0784439868', CAST(N'2001-12-09' AS Date), CAST(N'2020-09-14' AS Date), CAST(N'2023-09-14' AS Date), N'Đang hoạt động', 0, 1000.0000, 1)
INSERT [dbo].[TheKH] ([MaKh], [HoTen], [DChi], [SDT], [NgSinh], [NgDK], [HanThe], [Tinh_trang_the], [So_sach_dang_muon], [Tong_no], [So_lan_vi_pham]) VALUES (N'46733 ', N'Hoàng Mai Hiền', N'65/12 Nguyễn Tri Phương Q10 TPHCM', N'0816284951', CAST(N'1991-08-31' AS Date), CAST(N'2018-10-09' AS Date), CAST(N'2021-10-09' AS Date), N'Đang hoạt động', 2, 0.0000, 1)
INSERT [dbo].[TheKH] ([MaKh], [HoTen], [DChi], [SDT], [NgSinh], [NgDK], [HanThe], [Tinh_trang_the], [So_sach_dang_muon], [Tong_no], [So_lan_vi_pham]) VALUES (N'59024 ', N'Bùi Uyển Dao Uyên', N'32 Lý Tự Trọng Q1 TPHCM', N'0926378357', CAST(N'1997-10-23' AS Date), CAST(N'2019-01-06' AS Date), CAST(N'2022-01-06' AS Date), N'Đang hoạt động', 0, 50000.0000, 3)
INSERT [dbo].[TheKH] ([MaKh], [HoTen], [DChi], [SDT], [NgSinh], [NgDK], [HanThe], [Tinh_trang_the], [So_sach_dang_muon], [Tong_no], [So_lan_vi_pham]) VALUES (N'65767 ', N'Phạm Hữu Phúc', N'78 Lê Hồng Phong Q5 TPHCM', N'0729462856', CAST(N'1995-01-17' AS Date), CAST(N'2019-03-05' AS Date), CAST(N'2022-03-05' AS Date), N'Đang hoạt động', 2, 66000.0000, 4)
INSERT [dbo].[TheKH] ([MaKh], [HoTen], [DChi], [SDT], [NgSinh], [NgDK], [HanThe], [Tinh_trang_the], [So_sach_dang_muon], [Tong_no], [So_lan_vi_pham]) VALUES (N'67867 ', N'Phạm Bá Song Văn', N'154/6 Nguyễn Kim P12 Q4 TPHCM', N'0845888323', CAST(N'2001-11-28' AS Date), CAST(N'2018-07-30' AS Date), CAST(N'2021-07-30' AS Date), N'Đang hoạt động', 0, 0.0000, 0)
INSERT [dbo].[TheKH] ([MaKh], [HoTen], [DChi], [SDT], [NgSinh], [NgDK], [HanThe], [Tinh_trang_the], [So_sach_dang_muon], [Tong_no], [So_lan_vi_pham]) VALUES (N'76842 ', N'Lê Thành Huy', N'122 Nguyễn Văn Lượng P10 Q. Gò Vấp TPHCM', N'0905744733', CAST(N'1998-08-12' AS Date), CAST(N'2021-01-06' AS Date), CAST(N'2024-11-06' AS Date), N'Đang hoạt động', 3, 0.0000, 1)
INSERT [dbo].[TheKH] ([MaKh], [HoTen], [DChi], [SDT], [NgSinh], [NgDK], [HanThe], [Tinh_trang_the], [So_sach_dang_muon], [Tong_no], [So_lan_vi_pham]) VALUES (N'78900 ', N'Nguyễn Trần Thùy Dung', N'182 Bùi Thị Xuân Q1 TPHCM', N'0846289572', CAST(N'2002-05-22' AS Date), CAST(N'2020-02-22' AS Date), CAST(N'2023-02-22' AS Date), N'Đang hoạt động', 2, 0.0000, 0)
INSERT [dbo].[TheKH] ([MaKh], [HoTen], [DChi], [SDT], [NgSinh], [NgDK], [HanThe], [Tinh_trang_the], [So_sach_dang_muon], [Tong_no], [So_lan_vi_pham]) VALUES (N'84300 ', N'Lê Bảo Bảo', N'163/45 Trần Hưng Đạo Q1 TPHCM', N'0882478328', CAST(N'1998-09-10' AS Date), CAST(N'2018-01-28' AS Date), CAST(N'2021-01-28' AS Date), N'Không hoạt động', 0, 0.0000, 0)
INSERT [dbo].[TheKH] ([MaKh], [HoTen], [DChi], [SDT], [NgSinh], [NgDK], [HanThe], [Tinh_trang_the], [So_sach_dang_muon], [Tong_no], [So_lan_vi_pham]) VALUES (N'88992 ', N'Nguyễn Gia Lâm', N'12 Trần Phú Q5 TPHCM', N'0785385925', CAST(N'2003-06-28' AS Date), CAST(N'2021-03-09' AS Date), CAST(N'2024-03-09' AS Date), N'Đang hoạt động', 3, 40000.0000, 3)
GO
INSERT [dbo].[Phieu_muon] ([MaPhieu_muon], [MaKh], [Ngaymuon], [SL_sach_muon]) VALUES (N'M001', N'59024 ', CAST(N'2021-03-29' AS Date), 3)
INSERT [dbo].[Phieu_muon] ([MaPhieu_muon], [MaKh], [Ngaymuon], [SL_sach_muon]) VALUES (N'M002', N'65767 ', CAST(N'2021-04-06' AS Date), 3)
INSERT [dbo].[Phieu_muon] ([MaPhieu_muon], [MaKh], [Ngaymuon], [SL_sach_muon]) VALUES (N'M003', N'35866 ', CAST(N'2021-03-05' AS Date), 2)
INSERT [dbo].[Phieu_muon] ([MaPhieu_muon], [MaKh], [Ngaymuon], [SL_sach_muon]) VALUES (N'M004', N'46733 ', CAST(N'2021-05-01' AS Date), 2)
INSERT [dbo].[Phieu_muon] ([MaPhieu_muon], [MaKh], [Ngaymuon], [SL_sach_muon]) VALUES (N'M005', N'78900 ', CAST(N'2021-04-28' AS Date), 2)
INSERT [dbo].[Phieu_muon] ([MaPhieu_muon], [MaKh], [Ngaymuon], [SL_sach_muon]) VALUES (N'M006', N'13465 ', CAST(N'2021-04-19' AS Date), 1)
INSERT [dbo].[Phieu_muon] ([MaPhieu_muon], [MaKh], [Ngaymuon], [SL_sach_muon]) VALUES (N'M007', N'88992 ', CAST(N'2021-04-02' AS Date), 3)
INSERT [dbo].[Phieu_muon] ([MaPhieu_muon], [MaKh], [Ngaymuon], [SL_sach_muon]) VALUES (N'M008', N'59024 ', CAST(N'2021-04-21' AS Date), 2)
INSERT [dbo].[Phieu_muon] ([MaPhieu_muon], [MaKh], [Ngaymuon], [SL_sach_muon]) VALUES (N'M009', N'76842 ', CAST(N'2021-04-20' AS Date), 2)
INSERT [dbo].[Phieu_muon] ([MaPhieu_muon], [MaKh], [Ngaymuon], [SL_sach_muon]) VALUES (N'M010', N'21748 ', CAST(N'2021-04-23' AS Date), 3)
INSERT [dbo].[Phieu_muon] ([MaPhieu_muon], [MaKh], [Ngaymuon], [SL_sach_muon]) VALUES (N'M011', N'38592 ', CAST(N'2021-03-29' AS Date), 1)
INSERT [dbo].[Phieu_muon] ([MaPhieu_muon], [MaKh], [Ngaymuon], [SL_sach_muon]) VALUES (N'M012', N'27492 ', CAST(N'2021-03-17' AS Date), 1)
INSERT [dbo].[Phieu_muon] ([MaPhieu_muon], [MaKh], [Ngaymuon], [SL_sach_muon]) VALUES (N'M013', N'76842 ', CAST(N'2021-04-20' AS Date), 3)
INSERT [dbo].[Phieu_muon] ([MaPhieu_muon], [MaKh], [Ngaymuon], [SL_sach_muon]) VALUES (N'M014', N'88992 ', CAST(N'2021-04-30' AS Date), 2)
INSERT [dbo].[Phieu_muon] ([MaPhieu_muon], [MaKh], [Ngaymuon], [SL_sach_muon]) VALUES (N'M015', N'65767 ', CAST(N'2021-03-09' AS Date), 2)
INSERT [dbo].[Phieu_muon] ([MaPhieu_muon], [MaKh], [Ngaymuon], [SL_sach_muon]) VALUES (N'M016', N'35866 ', CAST(N'2021-01-12' AS Date), 2)
INSERT [dbo].[Phieu_muon] ([MaPhieu_muon], [MaKh], [Ngaymuon], [SL_sach_muon]) VALUES (N'M017', N'46733 ', CAST(N'2021-01-29' AS Date), 2)
INSERT [dbo].[Phieu_muon] ([MaPhieu_muon], [MaKh], [Ngaymuon], [SL_sach_muon]) VALUES (N'M018', N'88992 ', CAST(N'2021-04-30' AS Date), 1)
INSERT [dbo].[Phieu_muon] ([MaPhieu_muon], [MaKh], [Ngaymuon], [SL_sach_muon]) VALUES (N'M019', N'27492 ', CAST(N'2021-04-30' AS Date), 1)
INSERT [dbo].[Phieu_muon] ([MaPhieu_muon], [MaKh], [Ngaymuon], [SL_sach_muon]) VALUES (N'M020', N'65767 ', CAST(N'2021-04-27' AS Date), 3)
GO
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M001', N'DB01    ', CAST(N'2021-04-04' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M001', N'DMPLK01 ', CAST(N'2021-04-04' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M001', N'TD01    ', CAST(N'2021-04-04' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M002', N'CDMX01  ', CAST(N'2021-04-13' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M002', N'KAKN01  ', CAST(N'2021-04-13' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M002', N'SN01    ', CAST(N'2021-04-13' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M003', N'SD01    ', CAST(N'2021-03-12' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M003', N'TPOS01  ', CAST(N'2021-03-12' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M004', N'SD02    ', CAST(N'2021-05-07' AS Date), N'Đang mượn')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M004', N'TPOS02  ', CAST(N'2021-05-07' AS Date), N'Đang mượn')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M005', N'TDTA01  ', CAST(N'2021-05-04' AS Date), N'Đang mượn')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M005', N'YE01    ', CAST(N'2021-05-04' AS Date), N'Đang mượn')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M006', N'SNLG01  ', CAST(N'2021-04-26' AS Date), N'Quá hạn')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M007', N'HTTK01  ', CAST(N'2021-04-09' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M007', N'NCT01   ', CAST(N'2021-04-09' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M007', N'NDT01   ', CAST(N'2021-04-09' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M008', N'BSZ01   ', CAST(N'2021-04-28' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M008', N'TA1201  ', CAST(N'2021-04-28' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M009', N'D12     ', CAST(N'2021-04-27' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M009', N'OP07    ', CAST(N'2021-04-27' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M010', N'DB02    ', CAST(N'2021-04-30' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M010', N'DMPLK02 ', CAST(N'2021-04-30' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M010', N'DNT02   ', CAST(N'2021-04-30' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M011', N'D02     ', CAST(N'2021-04-05' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M012', N'D04     ', CAST(N'2021-03-24' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M013', N'KAKN02  ', CAST(N'2021-04-27' AS Date), N'Quá hạn')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M013', N'OP06    ', CAST(N'2021-04-27' AS Date), N'Quá hạn')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M013', N'TDK01   ', CAST(N'2021-04-27' AS Date), N'Quá hạn')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M014', N'SD01    ', CAST(N'2021-05-06' AS Date), N'Đang mượn')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M014', N'TQDN01  ', CAST(N'2021-05-06' AS Date), N'Đang mượn')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M015', N'TA1202  ', CAST(N'2021-03-16' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M015', N'TDTV02  ', CAST(N'2021-03-16' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M016', N'SNLG02  ', CAST(N'2021-01-19' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M016', N'TNHH01  ', CAST(N'2021-01-19' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M017', N'DTL01   ', CAST(N'2021-02-05' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M017', N'DTNC01  ', CAST(N'2021-02-05' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M018', N'OP05    ', CAST(N'2021-05-07' AS Date), N'Đang mượn')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M019', N'HNM01   ', CAST(N'2021-05-07' AS Date), N'Đang mượn')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M020', N'GPN02   ', CAST(N'2021-05-04' AS Date), N'Đã trả')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M020', N'HNM02   ', CAST(N'2021-05-04' AS Date), N'Đang mượn')
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu_muon], [MaSach], [Hantra], [Tinh_trang_muon]) VALUES (N'M020', N'TDTV03  ', CAST(N'2021-05-04' AS Date), N'Đang mượn')
GO
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M001', N'DB01    ', CAST(N'2021-04-04' AS Date), 7, 10000.0000, N'Hỏng', NULL)
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M001', N'DMPLK01 ', CAST(N'2021-04-04' AS Date), 7, 0.0000, N'Bình thường', NULL)
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M001', N'TD01    ', CAST(N'2021-04-04' AS Date), 7, 125000.0000, N'Đã mất', NULL)
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M002', N'CDMX01  ', CAST(N'2021-04-15' AS Date), 9, 51000.0000, N'Hỏng', N'Trả trễ 2 ngày')
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M002', N'KAKN01  ', CAST(N'2021-04-15' AS Date), 9, 125000.0000, N'Đã mất', NULL)
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M002', N'SN01    ', CAST(N'2021-04-15' AS Date), 9, 2000.0000, N'Bình thường', N'Trả trễ 2 ngày')
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M003', N'SD01    ', CAST(N'2021-03-19' AS Date), 14, 7000.0000, N'Bình thường', N'Trả trễ 7 ngày')
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M003', N'TPOS01  ', CAST(N'2021-03-19' AS Date), 14, 187500.0000, N'Hỏng', N'Trả trễ 7 ngày')
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M007', N'HTTK01  ', CAST(N'2021-04-10' AS Date), 8, 1000.0000, N'Bình thường', N'Trả trễ 1 ngày')
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M007', N'NCT01   ', CAST(N'2021-04-10' AS Date), 8, 90000.0000, N'Đã mất', N'trả trễ 1 ngày')
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M007', N'NDT01   ', CAST(N'2021-04-10' AS Date), 8, 1000.0000, N'Bình thường', N'Trả trễ 1 ngày')
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M008', N'BSZ01   ', CAST(N'2021-04-28' AS Date), 7, 0.0000, N'Bình thường', NULL)
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M008', N'TA1201  ', CAST(N'2021-04-28' AS Date), 7, 6000.0000, N'Hỏng', NULL)
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M009', N'D12     ', CAST(N'2021-04-28' AS Date), 8, 1000.0000, N'Bình thường', N'trả trễ 1 ngày')
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M009', N'OP07    ', CAST(N'2021-04-27' AS Date), 7, 0.0000, N'Bình thường', NULL)
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M010', N'DB02    ', CAST(N'2021-04-30' AS Date), 7, 0.0000, N'Bình thường', NULL)
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M010', N'DMPLK02 ', CAST(N'2021-04-30' AS Date), 7, 125000.0000, N'Hỏng', NULL)
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M010', N'DNT02   ', CAST(N'2021-05-02' AS Date), 9, 2000.0000, N'Bình thường', N'Trả trễ 2 ngày')
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M011', N'D02     ', CAST(N'2021-04-05' AS Date), 7, 11000.0000, N'Hỏng', NULL)
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M012', N'D04     ', CAST(N'2021-03-24' AS Date), 7, 0.0000, N'Bình thường', NULL)
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M015', N'TA1202  ', CAST(N'2021-03-16' AS Date), 7, 12000.0000, N'Đã mất', NULL)
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M015', N'TDTV02  ', CAST(N'2021-03-16' AS Date), 7, 0.0000, N'Bình thường', NULL)
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M016', N'SNLG02  ', CAST(N'2021-01-19' AS Date), 7, 265000.0000, N'Đã mất', NULL)
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M016', N'TNHH01  ', CAST(N'2021-01-19' AS Date), 7, 72500.0000, N'Hỏng', NULL)
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M017', N'DTL01   ', CAST(N'2021-02-05' AS Date), 7, 0.0000, N'Bình thường', NULL)
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M017', N'DTNC01  ', CAST(N'2021-02-05' AS Date), 7, 48000.0000, N'Hỏng', NULL)
INSERT [dbo].[PhieuTra] ([MaPhieu_muon], [MaSach], [NgayTra], [SoNgayMuon], [TienPhat], [Tinh_trang_tra_sach], [Ghi_chu]) VALUES (N'M020', N'GPN02   ', CAST(N'2021-05-04' AS Date), 7, 0.0000, N'Bình thường', NULL)
GO
INSERT [dbo].[Thu_tien_phat] ([MaPhat], [MaKh], [Li_do_vi_pham], [Tien_phat], [So_Tien_da_thu], [So_tien_con_no], [Ngay_thu]) VALUES (N'MP001', N'59024 ', N'Mất sách', 125000.0000, 75000.0000, 50000.0000, CAST(N'2021-04-04' AS Date))
INSERT [dbo].[Thu_tien_phat] ([MaPhat], [MaKh], [Li_do_vi_pham], [Tien_phat], [So_Tien_da_thu], [So_tien_con_no], [Ngay_thu]) VALUES (N'MP002', N'59024 ', N'Hỏng sách', 10000.0000, 10000.0000, 0.0000, CAST(N'2021-04-04' AS Date))
INSERT [dbo].[Thu_tien_phat] ([MaPhat], [MaKh], [Li_do_vi_pham], [Tien_phat], [So_Tien_da_thu], [So_tien_con_no], [Ngay_thu]) VALUES (N'MP003', N'65767 ', N'Mất sách', 125000.0000, 60000.0000, 65000.0000, CAST(N'2021-04-15' AS Date))
INSERT [dbo].[Thu_tien_phat] ([MaPhat], [MaKh], [Li_do_vi_pham], [Tien_phat], [So_Tien_da_thu], [So_tien_con_no], [Ngay_thu]) VALUES (N'MP004', N'65767 ', N'Trả trễ 2 ngày', 2000.0000, 2000.0000, 0.0000, CAST(N'2021-04-15' AS Date))
INSERT [dbo].[Thu_tien_phat] ([MaPhat], [MaKh], [Li_do_vi_pham], [Tien_phat], [So_Tien_da_thu], [So_tien_con_no], [Ngay_thu]) VALUES (N'MP005', N'65767 ', N'Hỏng sách, trả trễ 2 ngày', 51000.0000, 50000.0000, 1000.0000, CAST(N'2021-04-15' AS Date))
INSERT [dbo].[Thu_tien_phat] ([MaPhat], [MaKh], [Li_do_vi_pham], [Tien_phat], [So_Tien_da_thu], [So_tien_con_no], [Ngay_thu]) VALUES (N'MP006', N'35866 ', N'Trễ 7 ngày', 7000.0000, 7000.0000, 0.0000, CAST(N'2021-03-19' AS Date))
INSERT [dbo].[Thu_tien_phat] ([MaPhat], [MaKh], [Li_do_vi_pham], [Tien_phat], [So_Tien_da_thu], [So_tien_con_no], [Ngay_thu]) VALUES (N'MP007', N'35866 ', N'Hỏng sách', 187500.0000, 100000.0000, 87500.0000, CAST(N'2021-03-19' AS Date))
INSERT [dbo].[Thu_tien_phat] ([MaPhat], [MaKh], [Li_do_vi_pham], [Tien_phat], [So_Tien_da_thu], [So_tien_con_no], [Ngay_thu]) VALUES (N'MP008', N'88992 ', N'Trả trễ 1 ngày', 1000.0000, 1000.0000, 0.0000, CAST(N'2021-04-10' AS Date))
INSERT [dbo].[Thu_tien_phat] ([MaPhat], [MaKh], [Li_do_vi_pham], [Tien_phat], [So_Tien_da_thu], [So_tien_con_no], [Ngay_thu]) VALUES (N'MP009', N'88992 ', N'Trả trễ 1 ngày', 1000.0000, 1000.0000, 0.0000, CAST(N'2021-04-10' AS Date))
INSERT [dbo].[Thu_tien_phat] ([MaPhat], [MaKh], [Li_do_vi_pham], [Tien_phat], [So_Tien_da_thu], [So_tien_con_no], [Ngay_thu]) VALUES (N'MP010', N'88992 ', N'Mất sách, trả trễ 1 ngày', 90000.0000, 50000.0000, 40000.0000, CAST(N'2021-04-10' AS Date))
INSERT [dbo].[Thu_tien_phat] ([MaPhat], [MaKh], [Li_do_vi_pham], [Tien_phat], [So_Tien_da_thu], [So_tien_con_no], [Ngay_thu]) VALUES (N'MP011', N'59024 ', N'Hỏng sách', 6000.0000, 6000.0000, 0.0000, CAST(N'2021-04-28' AS Date))
INSERT [dbo].[Thu_tien_phat] ([MaPhat], [MaKh], [Li_do_vi_pham], [Tien_phat], [So_Tien_da_thu], [So_tien_con_no], [Ngay_thu]) VALUES (N'MP012', N'76842 ', N'Trả trễ 1 ngày', 1000.0000, 1000.0000, 0.0000, CAST(N'2021-04-28' AS Date))
INSERT [dbo].[Thu_tien_phat] ([MaPhat], [MaKh], [Li_do_vi_pham], [Tien_phat], [So_Tien_da_thu], [So_tien_con_no], [Ngay_thu]) VALUES (N'MP013', N'21748 ', N'Hỏng sách', 125000.0000, 125000.0000, 0.0000, CAST(N'2021-04-30' AS Date))
INSERT [dbo].[Thu_tien_phat] ([MaPhat], [MaKh], [Li_do_vi_pham], [Tien_phat], [So_Tien_da_thu], [So_tien_con_no], [Ngay_thu]) VALUES (N'MP014', N'21748 ', N'Trả trễ 2 ngày', 2000.0000, 2000.0000, 0.0000, CAST(N'2021-05-02' AS Date))
INSERT [dbo].[Thu_tien_phat] ([MaPhat], [MaKh], [Li_do_vi_pham], [Tien_phat], [So_Tien_da_thu], [So_tien_con_no], [Ngay_thu]) VALUES (N'MP015', N'38592 ', N'Hỏng sách', 11000.0000, 10000.0000, 1000.0000, CAST(N'2021-04-05' AS Date))
INSERT [dbo].[Thu_tien_phat] ([MaPhat], [MaKh], [Li_do_vi_pham], [Tien_phat], [So_Tien_da_thu], [So_tien_con_no], [Ngay_thu]) VALUES (N'MP016', N'65767 ', N'Mất sách', 12000.0000, 12000.0000, 0.0000, CAST(N'2021-03-16' AS Date))
INSERT [dbo].[Thu_tien_phat] ([MaPhat], [MaKh], [Li_do_vi_pham], [Tien_phat], [So_Tien_da_thu], [So_tien_con_no], [Ngay_thu]) VALUES (N'MP017', N'35866 ', N'Hỏng sách', 72500.0000, 72500.0000, 0.0000, CAST(N'2021-01-10' AS Date))
INSERT [dbo].[Thu_tien_phat] ([MaPhat], [MaKh], [Li_do_vi_pham], [Tien_phat], [So_Tien_da_thu], [So_tien_con_no], [Ngay_thu]) VALUES (N'MP018', N'35866 ', N'Mất sách', 265000.0000, 200000.0000, 65000.0000, CAST(N'2021-01-19' AS Date))
INSERT [dbo].[Thu_tien_phat] ([MaPhat], [MaKh], [Li_do_vi_pham], [Tien_phat], [So_Tien_da_thu], [So_tien_con_no], [Ngay_thu]) VALUES (N'MP019', N'46733 ', N'Hỏng', 48000.0000, 48000.0000, 0.0000, CAST(N'2021-02-05' AS Date))
GO
	SELECT*FROM dbo.TK_MuonSach
	SELECT*FROM dbo.TheLoai
	SELECT*FROM dbo.NXB
	SELECT*FROM dbo.Tinh_trang_sach
	SELECT*FROM dbo.TacGia
	SELECT*FROM dbo.SACH
	SELECT*FROM dbo.CTTK_MuonSach
	SELECT* FROM dbo.TheKH
	SELECT * FROM dbo.Phieu_muon
	SELECT*FROM dbo.CT_PhieuMuon
	SELECT* FROM dbo.Thu_tien_phat
	SELECT* FROM dbo.PhieuTra
	GO
	CREATE TRIGGER Update_soLuong1 ON dbo.Sach
FOR INSERT 
AS BEGIN
	DECLARE @So_luong_sach_XB INT;
	SELECT @So_luong_sach_XB = dbo.NXB.So_luong_sach_XB FROM dbo.NXB,Inserted WHERE Inserted.maNXB=dbo.NXB.MaNXB;
	BEGIN
	UPDATE dbo.NXB SET dbo.NXB.So_luong_sach_XB = dbo.NXB.So_luong_sach_XB +1  FROM dbo.NXB,Inserted WHERE Inserted.maNXB=dbo.NXB.MaNXB
	PRINT N'Chạy Trigger cập nhật số lượng đầu sách của NXB '
	END
	END
	GO
--Trigger cập nhật tổng tiền khách hàng còn đang nợ
CREATE TRIGGER  Update_Tong_no ON dbo.Thu_tien_phat
FOR INSERT
AS BEGIN
	DECLARE @So_no INT;
	SELECT @So_no = Inserted.So_tien_con_no FROM Inserted,dbo.Thu_tien_phat WHERE Inserted.MaPhat=dbo.Thu_tien_phat.MaPhat;
	BEGIN
	UPDATE dbo.TheKH SET Tong_no = Tong_no + (SELECT SUM(Inserted.So_tien_con_no) FROM dbo.TheKH,Inserted WHERE Inserted.MaKh =dbo.TheKH.MaKh GROUP BY TheKH.MaKh)
	PRINT N'Trigger cập nhật nợ'
	END
	END
	GO
--Trigger cập nhật sách đã mượn theo từng cuốn
CREATE TRIGGER Update_Sach_muon ON dbo.CT_PhieuMuon
FOR INSERT
AS BEGIN
	DECLARE @So_lan_muon INT;
	SELECT @So_lan_muon = dbo.CTTK_MuonSach.So_lan_muon_theo_tung_quyen FROM Inserted,dbo.CTTK_MuonSach WHERE Inserted.MaSach=dbo.CTTK_MuonSach.MaSach;
	BEGIN
	 UPDATE dbo.CTTK_MuonSach SET So_lan_muon_theo_tung_quyen = So_lan_muon_theo_tung_quyen +1 FROM dbo.CTTK_MuonSach,Inserted WHERE Inserted.MaSach= dbo.CTTK_MuonSach.MaSach
				PRINT N'Chạy Trigger cập nhật số sách mượn'
		END
	END
	GO

-- Thống kê mượn sách theo ngày tháng
CREATE PROCEDURE  Thongkehoadontheongaythang @ThangNam NVARCHAR(10)
AS
BEGIN
SET DATEFORMAT DMY
SELECT  dbo.Phieu_muon.Ngaymuon AS 'Ngày mượn', dbo.TheKH.HoTen AS 'Tên Khách hàng mượn' ,dbo.SACH.TenS AS 'Tên sách đã mượn',Phieu_muon.MaPhieu_muon
FROM dbo. Phieu_muon,dbo.TheKH ,dbo.SACH ,dbo.CT_PhieuMuon
WHERE  dbo.Phieu_muon.MaKh=dbo.TheKH.MaKh AND dbo.SACH.MaSach=dbo.CT_PhieuMuon.MaSach AND dbo.CT_PhieuMuon.MaPhieu_muon=dbo.Phieu_muon.MaPhieu_muon 
AND CONVERT(NVARCHAR(10),Ngaymuon,103) LIKE @ThangNam  
END
go
EXEC dbo.Thongkehoadontheongaythang @ThangNam = N'%04/2021'
go
--Thống kê những hóa đơn được lập trong khoảng thời gian nào
CREATE PROCEDURE  ThongkeHoadontheothoigian1 @TuNgay DATETIME, @DenNgay DATETIME
AS
BEGIN
SET DATEFORMAT DMY
SELECT CONVERT(varchar(10),CONVERT(DATETIME, @TuNgay),103) AS 'TuNgay', CONVERT(varchar(10),CONVERT(DATETIME,@DenNgay), 103) AS 'DenNgay',  Ngaymuon AS 'Ngày mượn', dbo.TheKH.HoTen AS 'Tên Khách hàng mượn',dbo.SACH.TenS AS 'Tên sách đã mượn'
FROM dbo. Phieu_muon,dbo.TheKH ,dbo.SACH,dbo.CT_PhieuMuon
WHERE  dbo.Phieu_muon.MaKh=dbo.TheKH.MaKh AND dbo.SACH.MaSach=dbo.CT_PhieuMuon.MaSach AND dbo.CT_PhieuMuon.MaPhieu_muon=dbo.Phieu_muon.MaPhieu_muon  AND	
 dbo.Phieu_muon.Ngaymuon >= CONVERT(varchar(10),CONVERT(DATETIME, @TuNgay), 103) and dbo.Phieu_muon.Ngaymuon <= CONVERT(varchar(10),CONVERT(DATETIME,@DenNgay), 103)
END
go
EXEC dbo.ThongkeHoadontheothoigian1 @TuNgay = '20210415', -- datetime
                                    @DenNgay = '20210430' -- datetime
GO
-- Thống kê mượn sách đã trả theo ngày tháng
CREATE PROCEDURE  Thongke_sach_da_tra_theongaythang @ThangNam NVARCHAR(10)
AS
BEGIN
SET DATEFORMAT DMY
SELECT  dbo.Phieutra.Ngaytra AS 'Ngày trả', dbo.TheKH.HoTen AS 'Tên Khách hàng đã trả' ,dbo.SACH.TenS AS 'Tên sách đã trả',Phieu_muon.MaPhieu_muon
FROM dbo. Phieu_muon,dbo.TheKH ,dbo.SACH ,dbo.Phieutra
WHERE  dbo.Phieu_muon.MaKh=dbo.TheKH.MaKh AND dbo.SACH.MaSach=dbo.phieutra.MaSach AND dbo.phieutra.MaPhieu_muon=dbo.Phieu_muon.MaPhieu_muon 
AND CONVERT(NVARCHAR(10),NgayTra,103) LIKE @ThangNam  
END
go
EXEC dbo.Thongke_sach_da_tra_theongaythang @ThangNam = N'%03/2021'
go

    
