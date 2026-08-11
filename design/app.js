/* ==========================================================================
   APP.JS - PROTOTYPE LOGIC
   Strictly aligned with docs/ & Natural Indonesian UX Copy
   ========================================================================== */

let currentRole = 'admin'; // 'admin' or 'client'
let theme = localStorage.getItem('app-theme') || 'system';
let activeScreen = 's01';
let currentScreenState = 'loaded'; // 'loaded', 'loading', 'empty', 'error'

// Search and Filter State
let clientSearchQuery = '';
let clientFilterClass = 'all';
let adminSearchQuery = '';
let adminFilterClass = 'all';

// Target for deletion
let deleteTargetId = null;

// Mock Source of Truth Data
let studentsData = [
  { id: 101, name: "Ahmad Rafli", nis: "210101", class: "XII IPA 1", gender: "Laki-laki", address: "Jl. Sudirman No. 10" },
  { id: 102, name: "Siti Nurhaliza", nis: "210102", class: "XII IPA 1", gender: "Perempuan", address: "Jl. Melati No. 5" },
  { id: 103, name: "Budi Santoso", nis: "210103", class: "XII IPA 2", gender: "Laki-laki", address: "Jl. Mawar No. 12" },
  { id: 104, name: "Dina Mariana", nis: "210104", class: "XII IPS 1", gender: "Perempuan", address: "Jl. Anggrek No. 8" },
  { id: 105, name: "Eko Prasetyo", nis: "210105", class: "XI IPA 1", gender: "Laki-laki", address: "Jl. Pahlawan No. 2" },
  { id: 106, name: "Fajar Hidayat", nis: "210106", class: "XI IPA 2", gender: "Laki-laki", address: "Jl. Pemuda No. 15" },
  { id: 107, name: "Gita Gutawa", nis: "210107", class: "XI IPS 1", gender: "Perempuan", address: "Jl. Cendrawasih No. 4" },
  { id: 108, name: "Hendra Wijaya", nis: "210108", class: "X IPA 1", gender: "Laki-laki", address: "Jl. Gajah Mada No. 9" },
  { id: 109, name: "Indah Permata", nis: "210109", class: "X IPA 2", gender: "Perempuan", address: "Jl. Hayam Wuruk No. 21" },
  { id: 110, name: "Joko Widodo", nis: "210110", class: "X IPS 1", gender: "Laki-laki", address: "Jl. Veteran No. 33" }
];

// Dynamic Classes List
let rombelList = ["X IPA 1", "X IPA 2", "X IPS 1", "XI IPA 1", "XI IPA 2", "XI IPS 1", "XII IPA 1", "XII IPA 2", "XII IPS 1"];

// Initialize App
document.addEventListener('DOMContentLoaded', () => {
  lucide.createIcons();
  setThemeMode(theme);
  updateRoleButtonsUI();
  navTo('s01');
  updateClock();
  setInterval(updateClock, 60000);
  enableMouseDragScroll();
});

// Enable Mouse Drag-to-Scroll for Chip Rows (Desktop UX)
function enableMouseDragScroll() {
  document.querySelectorAll('.chip-filter-row').forEach(slider => {
    let isDown = false;
    let startX;
    let scrollLeft;

    slider.addEventListener('mousedown', (e) => {
      isDown = true;
      startX = e.pageX - slider.offsetLeft;
      scrollLeft = slider.scrollLeft;
    });

    slider.addEventListener('mouseleave', () => { isDown = false; });
    slider.addEventListener('mouseup', () => { isDown = false; });

    slider.addEventListener('mousemove', (e) => {
      if (!isDown) return;
      e.preventDefault();
      const x = e.pageX - slider.offsetLeft;
      const walk = (x - startX) * 2;
      slider.scrollLeft = scrollLeft - walk;
    });
  });
}

// Toast Utility
function showToast(message) {
  const toast = document.getElementById('toast');
  const toastMsg = document.getElementById('toastMsg');
  if (!toast) return;

  toastMsg.innerText = message;
  toast.classList.add('active');

  setTimeout(() => {
    toast.classList.remove('active');
  }, 3000);
}

function refreshLucideIcons() {
  lucide.createIcons();
}

function cycleTheme() {
  if (theme === 'light') {
    setThemeMode('dark');
    showToast("Tema: GELAP");
  } else if (theme === 'dark') {
    setThemeMode('system');
    showToast("Tema: SISTEM");
  } else {
    setThemeMode('light');
    showToast("Tema: TERANG");
  }
}

// Theme Management (Light, Dark, System)
function setThemeMode(mode) {
  theme = mode;
  localStorage.setItem('app-theme', mode);
  
  if (mode === 'system') {
    delete document.documentElement.dataset.theme;
  } else {
    document.documentElement.dataset.theme = mode;
  }

  // Update Toolbar Pills
  const lightBtn = document.getElementById('themeLightBtn');
  const darkBtn = document.getElementById('themeDarkBtn');
  const sysBtn = document.getElementById('themeSystemBtn');
  if (lightBtn) lightBtn.classList.toggle('active', mode === 'light');
  if (darkBtn) darkBtn.classList.toggle('active', mode === 'dark');
  if (sysBtn) sysBtn.classList.toggle('active', mode === 'system');

  // Update S09 Segmented Control
  const segLight = document.getElementById('segLight');
  const segDark = document.getElementById('segDark');
  const segSystem = document.getElementById('segSystem');
  if (segLight) segLight.classList.toggle('active', mode === 'light');
  if (segDark) segDark.classList.toggle('active', mode === 'dark');
  if (segSystem) segSystem.classList.toggle('active', mode === 'system');

  // Update Login Theme Icon
  const loginThemeIcon = document.getElementById('loginThemeIcon');
  if (loginThemeIcon) {
    const iconName = mode === 'light' ? 'sun' : (mode === 'dark' ? 'moon' : 'monitor');
    loginThemeIcon.setAttribute('data-lucide', iconName);
  }

  refreshLucideIcons();
}

// Clock Status Bar
function updateClock() {
  const clockEl = document.getElementById('phoneClock');
  if (!clockEl) return;
  const now = new Date();
  clockEl.innerText = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`;
}

function highlightTab(code) {
  document.querySelectorAll('.tab-btn').forEach(btn => {
    if (btn.getAttribute('data-screen') === code) {
      btn.classList.add('active');
    } else {
      btn.classList.remove('active');
    }
  });
}

function checkStatePermission(actionType = 'general') {
  if (currentScreenState === 'loading') {
    showToast("Sedang memuat data... Mohon tunggu.");
    return false;
  }
  if (currentScreenState === 'error') {
    showToast("Koneksi bermasalah. Data tidak dapat diakses.");
    return false;
  }
  if (currentScreenState === 'empty' && (actionType === 'edit' || actionType === 'delete')) {
    showToast("Data kosong. Tidak ada data untuk diubah atau dihapus.");
    return false;
  }
  return true;
}

// Screen Navigation & Protection
function navTo(screenId, isManualClick = false, activeTabCode = null) {
  if (isManualClick) {
    closeModal('studentFormModal');
    closeModal('deleteConfirmDialog');
    closeModal('rombelFormModal');

    if (['s02', 's03'].includes(screenId) && currentRole !== 'client') {
      currentRole = 'client';
      updateRoleButtonsUI();
    } else if (['s04', 's05', 's06', 's07', 's08', 's10', 's11'].includes(screenId) && currentRole !== 'admin') {
      currentRole = 'admin';
      updateRoleButtonsUI();
    }
  } else {
    if (currentRole === 'client' && ['s04', 's05'].includes(screenId)) {
      screenId = 's02';
    }
    if (currentRole === 'admin' && ['s02', 's03'].includes(screenId)) {
      screenId = 's04';
    }
  }

  activeScreen = screenId;

  document.querySelectorAll('.screen-content').forEach(el => el.classList.remove('active'));

  const target = document.getElementById(`screen-${screenId}`);
  if (target) {
    target.classList.add('active');
  }

  highlightTab(activeTabCode || screenId);

  renderAppContent();
  updateProfileView();
  updateBottomNavForS09();
  refreshLucideIcons();
}

function updateRoleButtonsUI() {
  const clientBtn = document.getElementById('btnRoleClient');
  const adminBtn = document.getElementById('btnRoleAdmin');
  if (clientBtn) clientBtn.classList.toggle('active', currentRole === 'client');
  if (adminBtn) adminBtn.classList.toggle('active', currentRole === 'admin');

  document.querySelectorAll('.role-client-tab').forEach(el => el.style.display = currentRole === 'client' ? 'inline-flex' : 'none');
  document.querySelectorAll('.role-admin-tab').forEach(el => el.style.display = currentRole === 'admin' ? 'inline-flex' : 'none');
}

// Role Switcher
function switchRole(role) {
  currentRole = role;
  
  closeModal('studentFormModal');
  closeModal('deleteConfirmDialog');
  closeModal('rombelFormModal');

  updateRoleButtonsUI();

  if (role === 'client') {
    navTo('s02');
  } else {
    navTo('s04');
  }

  showToast(`Masuk sebagai ${role === 'admin' ? 'Admin' : 'Client'}`);
}

// Loading Spinner Helpers
function setLoadingState(btnId, isLoading) {
  const btn = document.getElementById(btnId);
  if (!btn) return;
  if (isLoading) {
    btn.classList.add('is-loading');
    btn.disabled = true;
  } else {
    btn.classList.remove('is-loading');
    btn.disabled = false;
  }
}

function quickLogin(role) {
  switchRole(role);
}

function handleLoginSubmit(e) {
  e.preventDefault();
  setLoadingState('btnLoginSubmit', true);
  
  const email = document.getElementById('loginEmail').value;
  
  setTimeout(() => {
    setLoadingState('btnLoginSubmit', false);
    if (email.includes('admin')) {
      quickLogin('admin');
    } else {
      quickLogin('client');
    }
  }, 600);
}

function handleLogout() {
  setLoadingState('btnLogout', true);
  setTimeout(() => {
    setLoadingState('btnLogout', false);
    navTo('s01');
    showToast("Kamu telah keluar dari akun.");
  }, 500);
}

function togglePasswordVisibility(inputId) {
  const input = document.getElementById(inputId);
  const eyeIcon = document.getElementById('eyeIcon');
  if (!input) return;
  
  if (input.type === 'password') {
    input.type = 'text';
    if (eyeIcon) eyeIcon.setAttribute('data-lucide', 'eye-off');
  } else {
    input.type = 'password';
    if (eyeIcon) eyeIcon.setAttribute('data-lucide', 'eye');
  }
  refreshLucideIcons();
}

// Advanced Search & Filter Logic
function handleClientFilter() {
  const input = document.getElementById('clientSearchInput');
  const clearBtn = document.getElementById('clientClearSearchBtn');
  clientSearchQuery = input.value.trim().toLowerCase();

  if (clearBtn) {
    clearBtn.classList.toggle('active', clientSearchQuery.length > 0);
  }
  renderAppContent();
}

function clearClientSearch() {
  const input = document.getElementById('clientSearchInput');
  const clearBtn = document.getElementById('clientClearSearchBtn');
  if (input) input.value = '';
  if (clearBtn) clearBtn.classList.remove('active');
  clientSearchQuery = '';
  renderAppContent();
}

function selectClientFilterChip(btn, className) {
  if (btn.parentElement) {
    btn.parentElement.querySelectorAll('.chip').forEach(c => c.classList.remove('active'));
  }
  btn.classList.add('active');
  clientFilterClass = className;
  renderAppContent();
}

function handleAdminFilter() {
  const input = document.getElementById('adminSearchInput');
  const clearBtn = document.getElementById('adminClearSearchBtn');
  adminSearchQuery = input.value.trim().toLowerCase();

  if (clearBtn) {
    clearBtn.classList.toggle('active', adminSearchQuery.length > 0);
  }
  renderAppContent();
}

function clearAdminSearch() {
  const input = document.getElementById('adminSearchInput');
  const clearBtn = document.getElementById('adminClearSearchBtn');
  if (input) input.value = '';
  if (clearBtn) clearBtn.classList.remove('active');
  adminSearchQuery = '';
  renderAppContent();
}

function selectAdminFilterChip(btn, className) {
  if (btn.parentElement) {
    btn.parentElement.querySelectorAll('.chip').forEach(c => c.classList.remove('active'));
  }
  btn.classList.add('active');
  adminFilterClass = className;
  renderAppContent();
}

function setScreenState(state) {
  currentScreenState = state;
  renderAppContent();
  showToast(`State: ${state.toUpperCase()}`);
}

/* ==========================================================================
   GLOBAL DATA RENDERING
   ========================================================================== */
function buildStateUI(type) {
  if (type === 'loading') return `<div style="display:flex; flex-direction:column; gap:12px;">${'<div class="skeleton skeleton-card"></div>'.repeat(4)}</div>`;
  if (type === 'empty') return `
    <div class="state-container">
      <div class="state-icon-box"><i data-lucide="inbox" class="icon-lg"></i></div>
      <div class="state-title">Belum Ada Data</div>
      <div class="state-desc">Data siswa belum tersedia saat ini.</div>
    </div>`;
  if (type === 'error') return `
    <div class="state-container">
      <div class="state-icon-box" style="color:var(--color-danger); background:var(--color-danger-bg);"><i data-lucide="alert-circle" class="icon-lg"></i></div>
      <div class="state-title text-danger">Gagal Memuat Data</div>
      <div class="state-desc">Periksa kembali koneksi internet kamu.</div>
    </div>`;
  return '';
}

function renderAppContent() {
  renderS02();
  renderS03();
  renderS04();
  renderS05();
  refreshLucideIcons();
}

// S02 — Client Home / Recap
function renderS02() {
  const container = document.getElementById('clientHomeScrollContainer');
  if (!container) return;

  if (currentScreenState !== 'loaded') {
    container.innerHTML = buildStateUI(currentScreenState);
    return;
  }

  const totalSiswa = studentsData.length;
  const rombelSet = [...new Set(studentsData.map(s => s.class))];
  const totalRombel = rombelSet.length;

  container.innerHTML = `
    <div class="card-base" style="background: var(--color-primary); color: white; border: none;">
      <div class="text-caption" style="opacity: 0.85;">Total Siswa</div>
      <div class="text-display" style="margin-top: 4px; color: white;">${totalSiswa} Siswa</div>
      <div class="text-caption" style="margin-top: 8px; opacity: 0.9;">Terbagi dalam ${totalRombel} kelas</div>
    </div>

    <div>
      <h3 class="text-section" style="margin-bottom: 12px;">Daftar Kelas</h3>
      <div style="display: flex; flex-direction: column; gap: 8px;">
        ${rombelSet.map(c => {
          const count = studentsData.filter(s => s.class === c).length;
          return `
            <div class="student-item">
              <div class="student-avatar" style="background:var(--color-primary-light); color:var(--color-primary);">
                <i data-lucide="book-open" class="icon-sm"></i>
              </div>
              <div class="student-details">
                <div class="student-name">Kelas ${c}</div>
                <div class="student-subinfo">${count} Siswa Terdaftar</div>
              </div>
            </div>
          `;
        }).join('')}
      </div>
    </div>
  `;
}

// S03 — Client Student List
function renderS03() {
  const container = document.getElementById('clientStudentListContainer');
  const chipContainer = document.getElementById('clientFilterChipsContainer');
  if (!container || !chipContainer) return;

  if (currentScreenState === 'loaded') {
    const allClasses = [...new Set([...rombelList, ...studentsData.map(s => s.class)])].sort();
    chipContainer.innerHTML = `
      <button type="button" class="chip ${clientFilterClass === 'all' ? 'active' : ''}" onclick="selectClientFilterChip(this, 'all')">Semua (${studentsData.length})</button>
      ${allClasses.map(c => {
        const count = studentsData.filter(s => s.class === c).length;
        return `<button type="button" class="chip ${clientFilterClass === c ? 'active' : ''}" onclick="selectClientFilterChip(this, '${c}')">${c} (${count})</button>`;
      }).join('')}
    `;
  }

  if (currentScreenState !== 'loaded') {
    container.innerHTML = buildStateUI(currentScreenState);
    return;
  }

  const clientFiltered = studentsData.filter(s => {
    const matchSearch = s.name.toLowerCase().includes(clientSearchQuery) || s.nis.includes(clientSearchQuery);
    const matchClass = clientFilterClass === 'all' || s.class === clientFilterClass;
    return matchSearch && matchClass;
  });

  if (clientFiltered.length === 0) {
    container.innerHTML = `
      <div class="state-container">
        <div class="state-icon-box"><i data-lucide="search-x" class="icon-lg"></i></div>
        <div class="state-title">Siswa Tidak Ditemukan</div>
        <div class="state-desc">Coba cek kembali kata kunci atau filter kelas kamu.</div>
      </div>`;
  } else {
    container.innerHTML = `
      <div class="text-caption text-muted" style="margin-bottom: 8px;">Menampilkan ${clientFiltered.length} dari ${studentsData.length} siswa</div>
      <div style="display:flex; flex-direction:column; gap:8px;">` + 
      clientFiltered.map(s => `
        <div class="student-item">
          <div class="student-avatar">${s.name.charAt(0)}</div>
          <div class="student-details">
            <div class="student-name">${s.name}</div>
            <div class="student-subinfo">NIS: ${s.nis} • <span class="badge badge-secondary">${s.class}</span></div>
          </div>
        </div>
      `).join('') + `</div>`;
  }
}

// S04 — Admin Dashboard
function renderS04() {
  const container = document.getElementById('adminDashboardScrollContainer');
  if (!container) return;

  if (currentScreenState !== 'loaded') {
    container.innerHTML = buildStateUI(currentScreenState);
    return;
  }

  container.innerHTML = `
    <div class="card-base">
      <div style="display:flex; justify-content:space-between; align-items:center;">
        <div>
          <div class="text-caption text-muted">Total Siswa Terdaftar</div>
          <div class="text-heading" style="margin-top: 2px;">${studentsData.length} Siswa</div>
        </div>
        <button type="button" class="btn btn-primary btn-sm" onclick="navTo('s05'); openAddModal();">
          <i data-lucide="plus" class="icon-sm"></i> Tambah Siswa
        </button>
      </div>
    </div>

    <div>
      <h3 class="text-section" style="margin-bottom: 12px;">Siswa Baru Ditambahkan</h3>
      <div style="display:flex; flex-direction:column; gap:8px;">
        ${studentsData.slice(0, 3).map(s => `
          <div class="student-item">
            <div class="student-avatar">${s.name.charAt(0)}</div>
            <div class="student-details">
              <div class="student-name">${s.name}</div>
              <div class="student-subinfo">NIS: ${s.nis} • ${s.class}</div>
            </div>
          </div>
        `).join('')}
      </div>
    </div>
  `;
}

// S05 — Admin Student Management (Primary CRUD)
function renderS05() {
  const container = document.getElementById('adminStudentListContainer');
  const chipContainer = document.getElementById('adminFilterChipsContainer');
  if (!container || !chipContainer) return;

  if (currentScreenState === 'loaded') {
    const allClasses = [...new Set([...rombelList, ...studentsData.map(s => s.class)])].sort();
    chipContainer.innerHTML = `
      <button type="button" class="chip ${adminFilterClass === 'all' ? 'active' : ''}" onclick="selectAdminFilterChip(this, 'all')">Semua (${studentsData.length})</button>
      ${allClasses.map(c => {
        const count = studentsData.filter(s => s.class === c).length;
        return `<button type="button" class="chip ${adminFilterClass === c ? 'active' : ''}" onclick="selectAdminFilterChip(this, '${c}')">${c} (${count})</button>`;
      }).join('')}
    `;
  }

  if (currentScreenState !== 'loaded') {
    container.innerHTML = buildStateUI(currentScreenState);
    return;
  }

  const adminFiltered = studentsData.filter(s => {
    const matchSearch = s.name.toLowerCase().includes(adminSearchQuery) || s.nis.includes(adminSearchQuery);
    const matchClass = adminFilterClass === 'all' || s.class === adminFilterClass;
    return matchSearch && matchClass;
  });

  if (adminFiltered.length === 0) {
    container.innerHTML = `
      <div class="state-container">
        <div class="state-icon-box"><i data-lucide="search-x" class="icon-lg"></i></div>
        <div class="state-title">Data Tidak Ditemukan</div>
        <div class="state-desc">Coba cek kata kunci atau hapus filter kelas.</div>
      </div>`;
  } else {
    container.innerHTML = `
      <div class="text-caption text-muted" style="margin-bottom: 8px;">Menampilkan ${adminFiltered.length} dari ${studentsData.length} siswa</div>
      <div style="display:flex; flex-direction:column; gap:8px;">` + 
      adminFiltered.map(s => `
        <div class="student-item">
          <div class="student-avatar">${s.name.charAt(0)}</div>
          <div class="student-details">
            <div class="student-name">${s.name}</div>
            <div class="student-subinfo">NIS: ${s.nis} • <span class="badge badge-secondary">${s.class}</span></div>
          </div>
          <div class="student-actions">
            <button type="button" class="btn-action-icon" onclick="openEditModal(${s.id})" aria-label="Edit Siswa"><i data-lucide="edit-2"></i></button>
            <button type="button" class="btn-action-icon btn-action-delete" onclick="openDeleteDialog('${s.name.replace(/'/g, "\\'")}', '${s.nis.replace(/'/g, "\\'")}', ${s.id})" aria-label="Hapus Siswa"><i data-lucide="trash-2"></i></button>
          </div>
        </div>
      `).join('') + `</div>`;
  }
}

/* ==========================================================================
   MODAL & CRUD FORM LOGIC
   ========================================================================== */
function clearValidationErrors() {
  document.querySelectorAll('.form-input, .form-select').forEach(el => el.classList.remove('is-invalid'));
  document.querySelectorAll('.field-error').forEach(el => {
    el.classList.remove('active');
    el.innerText = '';
  });
}

function showFieldError(inputId, errorId, message) {
  const input = document.getElementById(inputId);
  const errorSpan = document.getElementById(errorId);
  if (input) input.classList.add('is-invalid');
  if (errorSpan) {
    errorSpan.innerText = message;
    errorSpan.classList.add('active');
  }
}

function openAddModal() {
  if (!checkStatePermission('add')) return;
  highlightTab('s06');

  document.getElementById('formModalTitle').innerText = "Tambah Siswa Baru";
  document.getElementById('studentFormId').value = "";
  document.getElementById('inputName').value = "";
  document.getElementById('inputNIS').value = "";
  document.getElementById('selectClass').selectedIndex = 0;
  document.getElementById('genderL').checked = true;
  document.getElementById('inputAddress').value = "";

  clearValidationErrors();

  document.getElementById('modalOverlay').classList.add('active');
  document.getElementById('studentFormModal').classList.add('active');
  document.getElementById('deleteConfirmDialog').classList.remove('active');
  document.getElementById('rombelFormModal').classList.remove('active');
  refreshLucideIcons();
}

function openEditModal(studentId) {
  if (!checkStatePermission('edit')) return;
  highlightTab('s07');

  const student = studentsData.find(s => s.id === studentId);
  if (!student) return;

  document.getElementById('formModalTitle').innerText = "Ubah Data Siswa";
  document.getElementById('studentFormId').value = student.id;
  document.getElementById('inputName').value = student.name;
  document.getElementById('inputNIS').value = student.nis;
  document.getElementById('selectClass').value = student.class;

  if (student.gender === 'Perempuan') {
    document.getElementById('genderP').checked = true;
  } else {
    document.getElementById('genderL').checked = true;
  }

  document.getElementById('inputAddress').value = student.address || "";

  clearValidationErrors();

  document.getElementById('modalOverlay').classList.add('active');
  document.getElementById('studentFormModal').classList.add('active');
  document.getElementById('deleteConfirmDialog').classList.remove('active');
  document.getElementById('rombelFormModal').classList.remove('active');
  refreshLucideIcons();
}

function handleFormSubmit(e) {
  e.preventDefault();
  if (!checkStatePermission()) return;
  clearValidationErrors();

  const id = document.getElementById('studentFormId').value;
  const name = document.getElementById('inputName').value.trim();
  const nis = document.getElementById('inputNIS').value.trim();
  const className = document.getElementById('selectClass').value;
  const genderRadio = document.querySelector('input[name="gender"]:checked');
  const gender = genderRadio ? genderRadio.value : 'Laki-laki';
  const address = document.getElementById('inputAddress').value.trim();

  let hasError = false;
  if (!name) { showFieldError('inputName', 'errorName', 'Nama lengkap harus diisi'); hasError = true; }
  if (!nis) { showFieldError('inputNIS', 'errorNIS', 'NIS harus diisi angka'); hasError = true; }
  else if (!/^\d+$/.test(nis)) { showFieldError('inputNIS', 'errorNIS', 'NIS harus diisi angka'); hasError = true; }
  if (!className) { showFieldError('selectClass', 'errorClass', 'Pilih kelas terlebih dahulu'); hasError = true; }

  if (hasError) return;

  setLoadingState('btnSaveStudent', true);

  setTimeout(() => {
    setLoadingState('btnSaveStudent', false);
    if (id) {
      const index = studentsData.findIndex(s => s.id == id);
      if (index !== -1) {
        studentsData[index] = { id: parseInt(id), name, nis, class: className, gender, address };
        showToast("Data siswa berhasil diperbarui");
      }
    } else {
      const newId = Date.now();
      studentsData.unshift({ id: newId, name, nis, class: className, gender, address });
      showToast("Siswa baru berhasil ditambahkan");
    }

    closeModal('studentFormModal');
    renderAppContent();
  }, 500);
}

function openDeleteDialog(name, nis, id) {
  if (!checkStatePermission('delete')) return;
  highlightTab('s08');

  deleteTargetId = id;
  document.getElementById('deleteTargetName').innerText = name;
  document.getElementById('deleteTargetNIS').innerText = `NIS: ${nis}`;

  document.getElementById('modalOverlay').classList.add('active');
  document.getElementById('deleteConfirmDialog').classList.add('active');
  document.getElementById('studentFormModal').classList.remove('active');
  document.getElementById('rombelFormModal').classList.remove('active');
  refreshLucideIcons();
}

function executeDelete() {
  if (!deleteTargetId) return;
  if (!checkStatePermission('delete')) return;

  setLoadingState('btnConfirmDelete', true);
  
  setTimeout(() => {
    setLoadingState('btnConfirmDelete', false);
    studentsData = studentsData.filter(s => s.id !== deleteTargetId);
    showToast("Data siswa berhasil dihapus");
    closeModal('deleteConfirmDialog');
    renderAppContent();
  }, 500);
}

function closeModal(modalId) {
  const el = document.getElementById(modalId);
  if (el) el.classList.remove('active');
  
  const formModal = document.getElementById('studentFormModal');
  const dialogModal = document.getElementById('deleteConfirmDialog');
  const rombelModal = document.getElementById('rombelFormModal');
  
  const formActive = formModal && formModal.classList.contains('active');
  const dialogActive = dialogModal && dialogModal.classList.contains('active');
  const rombelActive = rombelModal && rombelModal.classList.contains('active');

  if (!formActive && !dialogActive && !rombelActive) {
    const overlay = document.getElementById('modalOverlay');
    if (overlay) overlay.classList.remove('active');
    highlightTab(activeScreen);
  }
}

// Rombel (Kelas) CRUD Logic
function renderRombelManager() {
  const container = document.getElementById('rombelListContainer');
  const section = document.getElementById('adminRombelSection');
  if (!container || !section) return;

  if (currentRole !== 'admin') {
    section.style.display = 'none';
    return;
  }
  section.style.display = 'block';

  container.innerHTML = rombelList.map(r => `
    <span class="chip" style="display:inline-flex; align-items:center; gap:6px; padding:4px 8px;">
      <span>${r}</span>
      <i data-lucide="edit-2" class="icon-sm text-muted" style="cursor:pointer;" title="Ubah Nama Kelas" onclick="openEditRombelModal('${r}')"></i>
      <i data-lucide="x" class="icon-sm text-danger" style="cursor:pointer;" title="Hapus Kelas" onclick="deleteRombel('${r}')"></i>
    </span>
  `).join('');

  updateSelectClassOptions();
  refreshLucideIcons();
}

function openAddRombelModal() {
  if (!checkStatePermission('add')) return;
  highlightTab('s10');

  document.getElementById('rombelModalTitle').innerText = "Tambah Kelas Baru";
  document.getElementById('inputRombelOldName').value = "";
  document.getElementById('inputRombelName').value = "";

  const errorSpan = document.getElementById('errorRombelName');
  const input = document.getElementById('inputRombelName');
  if (input) input.classList.remove('is-invalid');
  if (errorSpan) errorSpan.classList.remove('active');

  document.getElementById('modalOverlay').classList.add('active');
  document.getElementById('rombelFormModal').classList.add('active');
  document.getElementById('studentFormModal').classList.remove('active');
  document.getElementById('deleteConfirmDialog').classList.remove('active');
  refreshLucideIcons();
}

function openEditRombelModal(oldName) {
  if (!checkStatePermission('edit')) return;
  highlightTab('s11');

  document.getElementById('rombelModalTitle').innerText = "Ubah Nama Kelas";
  document.getElementById('inputRombelOldName').value = oldName;
  document.getElementById('inputRombelName').value = oldName;

  const errorSpan = document.getElementById('errorRombelName');
  const input = document.getElementById('inputRombelName');
  if (input) input.classList.remove('is-invalid');
  if (errorSpan) errorSpan.classList.remove('active');

  document.getElementById('modalOverlay').classList.add('active');
  document.getElementById('rombelFormModal').classList.add('active');
  document.getElementById('studentFormModal').classList.remove('active');
  document.getElementById('deleteConfirmDialog').classList.remove('active');
  refreshLucideIcons();
}

function handleRombelSubmit(e) {
  e.preventDefault();
  if (!checkStatePermission()) return;

  const oldName = document.getElementById('inputRombelOldName').value;
  const newName = document.getElementById('inputRombelName').value.trim();

  const errorSpan = document.getElementById('errorRombelName');
  const input = document.getElementById('inputRombelName');

  if (!newName) {
    if (input) input.classList.add('is-invalid');
    if (errorSpan) { errorSpan.innerText = "Nama kelas tidak boleh kosong"; errorSpan.classList.add('active'); }
    return;
  }

  setLoadingState('btnSaveRombel', true);

  setTimeout(() => {
    setLoadingState('btnSaveRombel', false);

    if (oldName) {
      const index = rombelList.indexOf(oldName);
      if (index !== -1) {
        rombelList[index] = newName;
        rombelList.sort();

        studentsData.forEach(s => {
          if (s.class === oldName) s.class = newName;
        });

        showToast(`Kelas ${oldName} berhasil diubah ke ${newName}`);
      }
    } else {
      if (!rombelList.includes(newName)) {
        rombelList.push(newName);
        rombelList.sort();
        showToast(`Kelas ${newName} berhasil ditambahkan`);
      } else {
        showToast(`Kelas ${newName} sudah ada`);
      }
    }

    closeModal('rombelFormModal');
    renderRombelManager();
    renderAppContent();
  }, 500);
}

function deleteRombel(name) {
  if (!checkStatePermission()) return;
  rombelList = rombelList.filter(r => r !== name);
  showToast(`Kelas ${name} berhasil dihapus`);
  renderRombelManager();
  renderAppContent();
}

function updateSelectClassOptions() {
  const select = document.getElementById('selectClass');
  if (!select) return;

  const currentVal = select.value;
  select.innerHTML = `
    <option value="" disabled ${!currentVal ? 'selected' : ''}>-- Pilih Kelas --</option>
    ${rombelList.map(r => `<option value="${r}" ${currentVal === r ? 'selected' : ''}>${r}</option>`).join('')}
  `;
}

// S09 Profile & Session Logic
function updateProfileView() {
  const profileAvatar = document.getElementById('profileAvatar');
  const profileName = document.getElementById('profileName');
  const profileEmail = document.getElementById('profileEmail');
  const profileBadge = document.getElementById('profileRoleBadge');

  if (!profileAvatar) return;

  if (currentRole === 'admin') {
    profileAvatar.innerText = "ADM";
    profileName.innerText = "Administrator Utama";
    profileEmail.innerText = "admin@sekolah.sch.id";
    profileBadge.innerText = "Peran: Admin";
    profileBadge.className = "badge badge-primary";
  } else {
    profileAvatar.innerText = "CLT";
    profileName.innerText = "Pengguna Client";
    profileEmail.innerText = "client@sekolah.sch.id";
    profileBadge.innerText = "Peran: Client";
    profileBadge.className = "badge badge-secondary";
  }

  renderRombelManager();
}

function updateBottomNavForS09() {
  const s09Nav = document.getElementById('s09BottomNav');
  if (!s09Nav) return;

  if (currentRole === 'admin') {
    s09Nav.innerHTML = `
      <button class="nav-item" onclick="navTo('s04')"><i data-lucide="layout-dashboard" class="nav-icon"></i><span class="nav-label">Dashboard</span></button>
      <button class="nav-item" onclick="navTo('s05')"><i data-lucide="users" class="nav-icon"></i><span class="nav-label">Kelola Siswa</span></button>
      <button class="nav-item active" onclick="navTo('s09')"><i data-lucide="user" class="nav-icon"></i><span class="nav-label">Profil</span></button>
    `;
  } else {
    s09Nav.innerHTML = `
      <button class="nav-item" onclick="navTo('s02')"><i data-lucide="home" class="nav-icon"></i><span class="nav-label">Beranda</span></button>
      <button class="nav-item" onclick="navTo('s03')"><i data-lucide="users" class="nav-icon"></i><span class="nav-label">Data Siswa</span></button>
      <button class="nav-item active" onclick="navTo('s09')"><i data-lucide="user" class="nav-icon"></i><span class="nav-label">Profil</span></button>
    `;
  }
  refreshLucideIcons();
}

function switchPanelTab(tabName) {
  const demoContent = document.getElementById('panelContentDemo');
  const handoffContent = document.getElementById('panelContentHandoff');
  const demoTab = document.getElementById('tabGuideDemo');
  const handoffTab = document.getElementById('tabGuideHandoff');

  if (tabName === 'handoff') {
    if (demoContent) demoContent.style.display = 'none';
    if (handoffContent) handoffContent.style.display = 'flex';
    if (demoTab) demoTab.classList.remove('active');
    if (handoffTab) handoffTab.classList.add('active');
  } else {
    if (demoContent) demoContent.style.display = 'flex';
    if (handoffContent) handoffContent.style.display = 'none';
    if (demoTab) demoTab.classList.add('active');
    if (handoffTab) handoffTab.classList.remove('active');
  }
  refreshLucideIcons();
}
