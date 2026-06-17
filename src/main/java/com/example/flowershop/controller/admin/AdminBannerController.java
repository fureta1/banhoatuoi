package com.example.flowershop.controller.admin;

import com.example.flowershop.dao.AdminBannerDAO;
import com.example.flowershop.model.Banner;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.File;
import java.io.IOException;
import java.util.List;

@Controller
@RequestMapping("/admin/banners")
public class AdminBannerController {

    @Autowired
    private AdminBannerDAO adminBannerDAO;

    // ===================== DANH SÁCH BANNER =====================
    @GetMapping
    public String list(Model model) {
        List<Banner> banners = adminBannerDAO.findAll();
        model.addAttribute("banners", banners);
        return "admin/banner-list";   // /WEB-INF/views/admin/banner-list.jsp
    }

    // ===================== FORM THÊM MỚI =====================
    @GetMapping("/create")
    public String createForm(Model model) {
        Banner banner = new Banner();
        banner.setStatus("active");
        banner.setDisplayOrder(0);
        model.addAttribute("banner", banner);
        model.addAttribute("formTitle", "Thêm banner mới");
        return "admin/banner-form";   // /WEB-INF/views/admin/banner-form.jsp
    }

    // ===================== FORM SỬA =====================
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable("id") Integer id, Model model) {
        Banner banner = adminBannerDAO.findById(id);
        model.addAttribute("banner", banner);
        model.addAttribute("formTitle", "Cập nhật banner");
        return "admin/banner-form";
    }

    // ===================== LƯU (THÊM / SỬA) =====================
@PostMapping("/save")
public String saveBanner(@ModelAttribute("banner") Banner banner,
                         @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                         HttpServletRequest request,
                         RedirectAttributes ra) {

    // 1. Validate: Banner mới bắt buộc phải có ảnh
    boolean isNew = (banner.getBannerId() == null);

    if (isNew) {
        boolean noOldImage = (banner.getImageUrl() == null || banner.getImageUrl().isBlank());
        boolean noNewUpload = (imageFile == null || imageFile.isEmpty());

        if (noOldImage && noNewUpload) {
            ra.addFlashAttribute("errorMessage", "Vui lòng chọn ảnh cho banner mới (image không được để trống).");
            ra.addFlashAttribute("banner", banner); // để fill lại form nếu cần
            return "redirect:/admin/banners/create";
        }
    }

    try {
        // 2. Xử lý upload ảnh
        String uploadDir = request.getServletContext().getRealPath("/images/banners");
        if (uploadDir == null) {
            uploadDir = new File("uploads/banners").getAbsolutePath();
        }

        File uploadFolder = new File(uploadDir);
        if (!uploadFolder.exists()) {
            uploadFolder.mkdirs();
        }

        if (imageFile != null && !imageFile.isEmpty()) {
            String originalFilename = imageFile.getOriginalFilename();
            String fileName = System.currentTimeMillis() + "_" + originalFilename;
            File dest = new File(uploadFolder, fileName);
            imageFile.transferTo(dest);

            banner.setImageUrl(fileName);
        }

        // 3. Insert / Update
        if (isNew) {
            adminBannerDAO.insert(banner);
            ra.addFlashAttribute("successMessage", "Thêm banner mới thành công!");
        } else {
            adminBannerDAO.update(banner);
            ra.addFlashAttribute("successMessage", "Cập nhật banner thành công!");
        }

    } catch (IOException e) {
        e.printStackTrace();
        ra.addFlashAttribute("errorMessage", "Lỗi upload ảnh banner, vui lòng thử lại.");
    } catch (Exception e) {
        e.printStackTrace();
        ra.addFlashAttribute("errorMessage", "Không thể lưu banner. Vui lòng kiểm tra dữ liệu.");
    }

    return "redirect:/admin/banners";
}


    // ===================== XÓA =====================
    @PostMapping("/delete")
    public String deleteBanner(@RequestParam("id") Integer id,
                               RedirectAttributes ra) {
        try {
            adminBannerDAO.delete(id);
            ra.addFlashAttribute("successMessage", "Đã xóa banner.");
        } catch (Exception e) {
            e.printStackTrace();
            ra.addFlashAttribute("errorMessage", "Không thể xóa banner: " + e.getMessage());
        }
        return "redirect:/admin/banners";
    }
}

