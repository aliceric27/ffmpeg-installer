# FFmpeg 自動安裝器

![Language](https://img.shields.io/badge/Language-Batch-blue)
![License](https://img.shields.io/badge/License-GPL-brightgreen)

這是一個 Windows 批次檔腳本，可以自動下載、安裝並配置 FFmpeg 到您的系統中。

## 功能特色

- 🚀 **自動下載**：從官方 GitHub 倉庫下載最新版本的 FFmpeg
- 📦 **自動解壓縮**：無需手動解壓縮檔案
- 🔧 **安全環境變數管理**：使用 PowerShell/.NET API 安全地修改 PATH，不會破壞現有環境變數
- 🛡️ **冪等性保證**：重複執行不會重複添加路徑或造成問題
- 🧹 **自動清理**：安裝完成後自動清理暫存檔案
- ✅ **安裝驗證**：自動驗證安裝是否成功
- 🔐 **權限檢測**：自動檢測管理員權限並選擇適當的安裝方式
- 📋 **詳細日誌**：提供清晰的安裝進度和狀態訊息

## 系統需求

- Windows 10/11 或 Windows Server 2016+
- PowerShell 5.0+ （Windows 10/11 內建）
- 網路連線（用於下載 FFmpeg）

## 使用方法

### 方法一：直接執行（推薦）

1. 下載 `install_ffmpeg.bat` 檔案
2. 以滑鼠右鍵點擊該檔案
3. 選擇「以系統管理員身分執行」（獲得最佳安裝體驗）
4. 按照螢幕指示等待安裝完成
5. 重新開啟命令提示字元或 PowerShell 視窗

### 方法二：命令列執行

```cmd
# 一般使用者權限（安裝到使用者環境變數）
install_ffmpeg.bat

# 管理員權限（安裝到系統環境變數，推薦）
# 以管理員身份開啟命令提示字元後執行
install_ffmpeg.bat
```

## 安裝位置

### 使用者權限安裝
- **安裝路徑**：`%USERPROFILE%\ffmpeg`
- **環境變數**：使用者 PATH

### 管理員權限安裝
- **安裝路徑**：`C:\ffmpeg`
- **環境變數**：系統 PATH

## 驗證安裝

安裝完成後，開啟新的命令提示字元或 PowerShell 視窗，輸入以下命令驗證：

```cmd
ffmpeg -version
```

如果看到 FFmpeg 的版本資訊，表示安裝成功。

## 故障排除

### 下載失敗
- **原因**：網路連線問題或防火牆阻擋
- **解決方案**：
  - 檢查網路連線
  - 暫時關閉防火牆或防毒軟體
  - 使用 VPN 或代理伺服器

### 權限不足
- **症狀**：無法建立目錄或設定環境變數
- **解決方案**：以管理員身份執行腳本

### 環境變數未生效
- **症狀**：安裝完成但 `ffmpeg` 命令無法識別
- **解決方案**：
  - 重新開啟命令提示字元視窗
  - 登出並重新登入 Windows 帳戶
  - 重新啟動電腦

### 解壓縮失敗
- **原因**：磁碟空間不足或檔案損壞
- **解決方案**：
  - 確保有足夠的磁碟空間（建議至少 500MB）
  - 重新執行安裝腳本

## 手動移除

如需移除 FFmpeg，請執行以下步驟：

1. 刪除安裝目錄：
   ```cmd
   # 使用者安裝
   rmdir /s "%USERPROFILE%\ffmpeg"
   
   # 系統安裝
   rmdir /s "C:\ffmpeg"
   ```

2. 從環境變數移除路徑：
   - 開啟「系統內容」→「進階」→「環境變數」
   - 在 PATH 變數中移除 FFmpeg 相關路徑

## 技術細節

### 下載來源
- **官方倉庫**：[BtbN/FFmpeg-Builds](https://github.com/BtbN/FFmpeg-Builds)
- **版本**：master-latest-win64-gpl-shared
- **授權**：GPL

### 腳本功能
- 使用 PowerShell 進行 HTTP 下載
- 自動檢測解壓縮後的目錄結構
- **安全的環境變數管理**：
  - 使用 `System.Environment.GetEnvironmentVariable()` 正確讀取現有 PATH
  - 使用 `System.Environment.SetEnvironmentVariable()` 安全修改 PATH
  - 避免覆蓋現有環境變數的問題
  - 支援 User 和 Machine 兩種作用範圍
- 完整的錯誤處理機制
- 冪等性設計：重複執行安全無害

### 安全性保證
- ❌ **不使用危險的 `setx` 命令**：避免 PATH 覆蓋問題
- ✅ **使用官方 .NET API**：通過 PowerShell 調用 Windows 官方環境變數 API
- ✅ **智慧重複檢測**：自動檢測路徑是否已存在，避免重複添加
- ✅ **作用範圍隔離**：明確區分用戶級和系統級環境變數

## 授權條款

此安裝腳本為開源軟體，FFmpeg 本身遵循 GPL 授權條款。

## 支援與回饋

如有問題或建議，請提出 Issue 或聯繫開發者。

---

**注意**：首次安裝後請重新開啟命令列視窗，新的環境變數才會生效。