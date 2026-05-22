# Workflow Lam Viec Voi Codex

Tai lieu nay dung de lam viec nhanh va on dinh voi repo `Book_VaR` trong Codex.

## 1. Muc tieu repo

Repo nay la mot du an sach Quarto su dung R, `renv`, va dau ra chinh la PDF.

Cac diem quan trong:

- Noi dung sach nam o `index.qmd`, `chapters/*.qmd`, `references.qmd`.
- Cau hinh sach nam o `_quarto.yml`.
- Du lieu nam o `data/`.
- Tai lieu tham khao nam o `references.bib`, `references_volatility_var.bib`, `2. Book Reference/`.
- Dau ra build nam o `_book/`.
- Ket qua cache va freeze nam o `_freeze/`, `chapters/*_files/`, `chapters/*_cache/`.

## 2. Cach bat dau moi phien

Lam theo thu tu nay:

1. Mo repo goc: `/Users/trungvic/Documents/Codex/2026-05-22/h-y-source-git-n-y/Book_VaR`.
2. Bao Codex muc tieu cua phien lam viec.
3. Neu can chay code R, khoi phuc goi bang `renv::restore()`.
4. Neu can build sach, dam bao Quarto da duoc cai trong may.
5. Truoc khi sua lon, yeu cau Codex doc `_quarto.yml`, `index.qmd`, va chuong lien quan.

Prompt mau:

```text
Doc nhanh cau truc repo nay, tom tat workflow build, sau do ho tro toi sua Chapter 3 ma khong lam vo cac file khac.
```

## 3. Workflow hang ngay de lam viec voi Codex

### Sua noi dung hoc thuat

Dung khi can viet, rut gon, hoac sap xep lai lap luan trong chuong.

Prompt mau:

```text
Doc chapters/ch03.qmd va giup toi viet lai theo van phong hoc thuat, giu nguyen y nghia, uu tien ro rang va lien mach.
```

### Sua code R trong chuong

Dung khi can sua chunk, bo sung phan tich, doi bieu do, hoac sua loi tinh toan.

Prompt mau:

```text
Kiem tra chapters/ch05.qmd, tim cac chunk tinh VaR, giai thich logic, sau do sua cho de tai su dung hon.
```

### Them chuong hoac them muc

Dung khi mo rong noi dung sach.

Prompt mau:

```text
Tao them mot muc moi trong chapters/ch05.qmd ve backtesting VaR, viet theo phong cach dong nhat voi cac muc hien co.
```

### Ra soat truoc khi commit

Dung khi muon kiem tra sai logic, sai tham chieu, sai ten hinh, hoac noi dung trung lap.

Prompt mau:

```text
Review cac thay doi hien tai theo huong bug va regression, uu tien loi build Quarto, loi tham chieu, va loi chunk R.
```

## 4. Nguyen tac lam viec nen dung

- Moi tac vu nen chi tap trung vao 1 chuong hoac 1 muc tieu ro rang.
- Truoc khi sua, bao Codex xac dinh file se dong vao.
- Sau khi sua xong, bao Codex tu kiem tra tac dong lan can nhu cross-reference, bibliography, ten hinh, va chunk R lien quan.
- Neu sua noi dung hoc thuat, yeu cau Codex khong lam thay doi thong diep hoc thuat neu ban chua xac nhan.
- Neu sua code, yeu cau Codex tach ro phan "giai thich", "thay doi", va "cach kiem tra".

## 5. Build va kiem tra

Repo dang dung:

- R qua `.Rprofile` va `renv/activate.R`
- Quarto book qua `_quarto.yml`
- PDF output trong `_book/`

Cac buoc kiem tra khuyen nghi:

1. Khoi phuc package R neu can.
2. Render sach hoac render chuong lien quan.
3. Kiem tra file PDF dau ra.
4. Kiem tra `_book/` va cac canh bao sinh ra trong qua trinh render.

Neu may chua co Quarto, can cai truoc khi render.

## 6. Quy uoc de Codex giup tot hon

Moi khi giao viec, nen noi ro:

- File nao duoc sua.
- Muc tieu cu the.
- Muc nao khong duoc dong vao.
- Ban muon uu tien noi dung, code R, hay build.

Prompt mau:

```text
Chi sua chapters/ch03.qmd. Muc tieu la lam ro phan EWMA va GARCH. Khong doi ten section, khong sua cac chuong khac, va bao toi neu can doi du lieu dau vao.
```

## 7. Workflow de xuat theo tinh huong

### Truong hop 1: Viet noi dung moi

1. Bao Codex doc chuong lien quan.
2. Yeu cau de xuat dan y ngan.
3. Chon phien ban phu hop.
4. Yeu cau Codex chen noi dung vao file that su.
5. Kiem tra lai cross-reference va van phong.

### Truong hop 2: Sua loi build

1. Bao Codex xac dinh file gay loi.
2. Yeu cau tach loi noi dung va loi code.
3. Sua toi thieu de build lai duoc.
4. Chay kiem tra lai.

### Truong hop 3: Nang cap chat luong chuong

1. Bao Codex review chuong.
2. Lay danh sach van de uu tien cao.
3. Sua tung nhom van de.
4. Review lan cuoi truoc khi commit.

## 8. Nen bat dau bang prompt nao

Neu ban muon bat dau ngay, day la prompt tot:

```text
Hay dong vai tro tro ly bien tap va ky thuat cho repo sach Quarto nay. Doc _quarto.yml, index.qmd va file chapter toi chi dinh. Moi lan lam viec, hay:
1. tom tat nhanh ban se sua gi,
2. chi dong vao dung file can thiet,
3. bao lai cach kiem tra sau khi sua.
Bat dau bang cach review chapters/ch03.qmd cho toi.
```
