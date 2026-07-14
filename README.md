# xlist

English | [中文](./README_zh.md)

<a href='https://apps.apple.com/cn/app/id6448833200'><image src='https://xlist.site/assets/images/app-store-badge.png' width='200' /></a>
<a href='https://play.google.com/store/apps/details?id=io.xlist'><image src='https://xlist.site/assets/images/google-play-badge.png' width='200' /></a>
<a href='https://github.com/xlist-io/xlist/releases'><image src='https://xlist.site/assets/images/android-apk-badge.png' width='200' /></a>

Xlist is an [Alist](https://alist.nn.ci/zh) client where you can configure multiple [Alist](https://alist.nn.ci/zh) servers for file management and previewing, supporting online previewing of multiple video formats and document formats.

> - Support downloading, renaming, moving and copying of files.
> - Supports online preview of files in doc, docx, xls, xlsx, ppt, pptx, pdf formats.
> - Supports online preview of most videos such as mp4, mkv, avi, flv, etc. Also supports srt and vtt subtitle plugins.
> - Support jpg, png, gif and other formats of pictures online preview.
> - Background download function, you can open the preview file with other apps after the download is completed.

##

<p><image src='https://xlist.site/assets/snapshots/homepage.png' width='200' /><image src='https://xlist.site/assets/snapshots/video_player.png' width='200' /><image src='https://xlist.site/assets/snapshots/download.png' width='200' /><image src='https://xlist.site/assets/snapshots/settings.png' width='200' /></p>

## Các thay đổi và tối ưu hóa (So với Repo gốc) / Custom Modifications

Bản fork này đã được sửa đổi và tối ưu hóa một số điểm kỹ thuật dưới đây:

### 1. Sửa lỗi build APK trên GitHub Actions
* **Đồng bộ hóa JVM Target:** Khắc phục lỗi `Inconsistent JVM-target compatibility` bằng cách ép toàn bộ các subprojects/plugins sử dụng thống nhất **Java 17** và **Kotlin JVM Target 17** trong file [build.gradle](file:///d:/Personal%20Project/xlist/android/build.gradle).
* **Fix lỗi vòng đời build Gradle:** Khắc phục lỗi `Cannot run Project.afterEvaluate(Closure) when the project is already evaluated` bằng việc kiểm tra trạng thái `project.state.executed` của các plugin trước khi gọi `afterEvaluate`.
* **Fix lỗi flutter_gen compiler:** Khóa phiên bản cài đặt global `flutter_gen` ở bản `5.5.0+1` tương thích với SDK Dart 3.3.x của Flutter `3.19.6` trong [build.yml](file:///d:/Personal%20Project/xlist/.github/workflows/build.yml), tránh lỗi cú pháp `latestLanguageVersion` của phiên bản mới nhất.
* **Xóa tham số build lỗi:** Loại bỏ tham số build không hợp lệ `--android-skip-build-dependency-validation` trong [build.yml](file:///d:/Personal%20Project/xlist/.github/workflows/build.yml) vì không được hỗ trợ ở Flutter 3.19.6.

### 2. Tự động tải file APK lên GitHub Releases
* Cấu hình CI/CD trong [build.yml](file:///d:/Personal%20Project/xlist/.github/workflows/build.yml) tự động phát hiện khi bạn push một tag mới (định dạng `v*` như `v1.0.0`), sau đó tự động tạo một GitHub Release mới tương ứng và đính kèm file APK vừa build thành công lên đó.

### 3. Sửa lỗi Runtime khi lưu Server AList mới
* **Khắc phục lỗi ép kiểu dữ liệu `role`:** Trên các phiên bản AList mới, API `/api/me` trả về trường `role` ở dạng mảng `List<dynamic>` thay vì một số nguyên `int` như cũ, dẫn đến lỗi runtime: `type 'List<dynamic>' is not a subtype of type 'num?' in type cast` khi bấm Save.
* **Giải pháp:** Cập nhật lại logic parse JSON trong Model [user.dart](file:///d:/Personal%20Project/xlist/lib/models/user.dart) (và cập nhật [user.g.dart](file:///d:/Personal%20Project/xlist/lib/models/user.g.dart)) thông qua hàm custom deserializer. Giờ đây app tương thích tốt và chạy mượt mà trên cả máy chủ AList cũ (trả về `int`) lẫn AList mới (trả về `List`).
