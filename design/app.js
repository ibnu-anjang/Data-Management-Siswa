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
let clientFilterGender = 'all';
let clientFilterStatus = 'all';

let adminSearchQuery = '';
let adminFilterClass = 'all';
let adminFilterGender = 'all';
let adminFilterStatus = 'all';

let activeFilterTargetRole = 'admin';

// Target for deletion
let deleteTargetId = null;

// Mock Source of Truth Data
let studentsData = [
  { id: 101, name: "Ahmad Rafli", nis: "210101", class: "XII IPA 1", gender: "Laki-laki", address: "Jl. Sudirman No. 10", birthDate: "15 Mei 2007", religion: "Islam", guardianName: "Bpk. Subagyo", guardianPhone: "0812-3456-7890", status: "Aktif" },
  { id: 102, name: "Siti Nurhaliza", nis: "210102", class: "XII IPA 1", gender: "Perempuan", address: "Jl. Melati No. 5", birthDate: "20 Agustus 2007", religion: "Islam", guardianName: "Ibu Rahmawati", guardianPhone: "0813-8877-6655", status: "Aktif" },
  { id: 103, name: "Budi Santoso", nis: "210103", class: "XII IPA 2", gender: "Laki-laki", address: "Jl. Mawar No. 12", birthDate: "10 Januari 2007", religion: "Kristen", guardianName: "Bpk. Santoso", guardianPhone: "0815-9988-1122", status: "Aktif" },
  { id: 104, name: "Dina Mariana", nis: "210104", class: "XII IPS 1", gender: "Perempuan", address: "Jl. Anggrek No. 8", birthDate: "05 November 2007", religion: "Islam", guardianName: "Bpk. Bambang", guardianPhone: "0821-4433-2211", status: "Aktif" },
  { id: 105, name: "Eko Prasetyo", nis: "210105", class: "XI IPA 1", gender: "Laki-laki", address: "Jl. Pahlawan No. 2", birthDate: "18 Juli 2008", religion: "Islam", guardianName: "Ibu Kartini", guardianPhone: "0856-7788-9900", status: "Aktif" },
  { id: 106, name: "Fajar Hidayat", nis: "210106", class: "XI IPA 2", gender: "Laki-laki", address: "Jl. Pemuda No. 15", birthDate: "22 April 2008", religion: "Islam", guardianName: "Bpk. Hidayat", guardianPhone: "0812-1111-2222", status: "Aktif" },
  { id: 107, name: "Gita Gutawa", nis: "210107", class: "XI IPS 1", gender: "Perempuan", address: "Jl. Cendrawasih No. 4", birthDate: "11 Agustus 2008", religion: "Katolik", guardianName: "Bpk. Erwin", guardianPhone: "0813-3333-4444", status: "Aktif" },
  { id: 108, name: "Hendra Wijaya", nis: "210108", class: "X IPA 1", gender: "Laki-laki", address: "Jl. Gajah Mada No. 9", birthDate: "30 Desember 2009", religion: "Budha", guardianName: "Bpk. Wijaya", guardianPhone: "0817-5555-6666", status: "Aktif" },
  { id: 109, name: "Indah Permata", nis: "210109", class: "X IPA 2", gender: "Perempuan", address: "Jl. Hayam Wuruk No. 21", birthDate: "04 Februari 2009", religion: "Islam", guardianName: "Ibu Syamsiah", guardianPhone: "0818-7777-8888", status: "Aktif" },
  { id: 110, name: "Joko Widodo", nis: "210110", class: "X IPS 1", gender: "Laki-laki", address: "Jl. Veteran No. 33", birthDate: "21 Juni 2009", religion: "Islam", guardianName: "Bpk. Notomihardjo", guardianPhone: "0819-9999-0000", status: "Aktif" }
];

// Dynamic Classes List
let rombelList = ["X IPA 1", "X IPA 2", "X IPS 1", "XI IPA 1", "XI IPA 2", "XI IPS 1", "XII IPA 1", "XII IPA 2", "XII IPS 1"];

// Dynamic School Profile State (CRUD Identitas Sekolah)
let schoolProfile = {
  name: "SMK AK Nusa Bangsa",
  npsn: "20103456",
  address: "Jl. KH. Sholeh Iskandar No. 1, Bogor",
  phone: "(0251) 8345678",
  email: "info@smk-aknusalab.sch.id",
  academicYear: "2025/2026",
  semester: "Semester Genap",
  principalName: "Drs. H. Ahmad Fauzi, M.Pd.",
  principalNip: "19720815 199803 1 004"
};

// Initialize App
document.addEventListener('DOMContentLoaded', () => {
  lucide.createIcons();
  setThemeMode(theme);
  updateRoleButtonsUI();

  const savedPanel = localStorage.getItem('panel-collapsed');
  if (savedPanel === 'true') {
    togglePresentationPanel(true);
  }

  navTo('s01');
  updateClock();
  setInterval(updateClock, 60000);
  enableMouseDragScroll();
});

// Enable Mouse Drag-to-Scroll & Mouse Wheel Scroll for Horizontal Containers (Desktop UX)
function enableMouseDragScroll() {
  const scrollContainers = document.querySelectorAll('.chip-filter-row, .screen-tabs-container');
  
  scrollContainers.forEach(slider => {
    let isDown = false;
    let startX;
    let scrollLeft;

    // Mouse wheel horizontal scrolling
    slider.addEventListener('wheel', (e) => {
      if (e.deltaY !== 0) {
        e.preventDefault();
        slider.scrollLeft += e.deltaY;
      }
    }, { passive: false });

    // Drag-to-scroll
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
      btn.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'center' });
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
function openFilterBottomSheet(role = 'admin') {
  activeFilterTargetRole = role;
  const isClient = role === 'client';

  const currentClass = isClient ? clientFilterClass : adminFilterClass;
  const currentGender = isClient ? clientFilterGender : adminFilterGender;
  const currentStatus = isClient ? clientFilterStatus : adminFilterStatus;

  const selectClass = document.getElementById('filterSelectClass');
  if (selectClass) {
    const allClasses = [...new Set([...rombelList, ...studentsData.map(s => s.class)])].sort();
    selectClass.innerHTML = `<option value="all">-- Semua Rombel (Semua Kelas) --</option>` +
      allClasses.map(c => `<option value="${c}" ${c === currentClass ? 'selected' : ''}>Kelas ${c}</option>`).join('');
  }

  const selectGender = document.getElementById('filterSelectGender');
  if (selectGender) selectGender.value = currentGender;

  const selectStatus = document.getElementById('filterSelectStatus');
  if (selectStatus) selectStatus.value = currentStatus;

  openModal('filterBottomSheetModal');
}

function applyBottomSheetFilters() {
  const isClient = activeFilterTargetRole === 'client';
  const selClass = document.getElementById('filterSelectClass').value;
  const selGender = document.getElementById('filterSelectGender').value;
  const selStatus = document.getElementById('filterSelectStatus').value;

  if (isClient) {
    clientFilterClass = selClass;
    clientFilterGender = selGender;
    clientFilterStatus = selStatus;
  } else {
    adminFilterClass = selClass;
    adminFilterGender = selGender;
    adminFilterStatus = selStatus;
  }

  closeModal('filterBottomSheetModal');
  renderAppContent();
  showToast("Filter berhasil diterapkan!");
}

function resetBottomSheetFilters() {
  const selectClass = document.getElementById('filterSelectClass');
  const selectGender = document.getElementById('filterSelectGender');
  const selectStatus = document.getElementById('filterSelectStatus');
  if (selectClass) selectClass.value = 'all';
  if (selectGender) selectGender.value = 'all';
  if (selectStatus) selectStatus.value = 'all';

  applyBottomSheetFilters();
}

function resetBottomSheetFiltersFor(role) {
  if (role === 'client') {
    clientFilterClass = 'all';
    clientFilterGender = 'all';
    clientFilterStatus = 'all';
  } else {
    adminFilterClass = 'all';
    adminFilterGender = 'all';
    adminFilterStatus = 'all';
  }
  renderAppContent();
  showToast("Filter di-reset!");
}

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

function selectClientFilterClassDirect(className) {
  clientFilterClass = className;
  navTo('s03');
  showToast(`Menampilkan siswa kelas ${className}`);
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
  const rombelSet = [...new Set(studentsData.map(s => s.class))].sort();
  const totalRombel = rombelSet.length;

  container.innerHTML = `
    <!-- Top Summary Hero Card -->
    <div class="card-base" style="padding:16px; background:var(--color-surface); border:1px solid var(--color-border); border-radius:var(--radius-md);">
      <div style="display:flex; justify-content:space-between; align-items:center;">
        <div>
          <span class="text-caption text-muted" style="font-weight:500;">Ringkasan Total Siswa</span>
          <div class="text-display" style="color:var(--color-primary); font-size:26px; font-weight:700; margin-top:2px;">${totalSiswa} Siswa</div>
          <div style="margin-top:6px; display:flex; gap:6px;">
            <span class="badge badge-primary" style="font-size:10px;">${totalRombel} Rombel Aktif</span>
            <span class="badge badge-secondary" style="font-size:10px;">${schoolProfile.name}</span>
          </div>
        </div>
        <div style="width:48px; height:48px; border-radius:12px; background:var(--color-primary-light); color:var(--color-primary); display:flex; align-items:center; justify-content:center; flex-shrink:0;">
          <i data-lucide="graduation-cap" class="icon-lg"></i>
        </div>
      </div>
    </div>

    <!-- Rombel List Section -->
    <div style="margin-top:4px;">
      <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
        <h3 class="text-section">Daftar Kelas (Rombel)</h3>
        <span class="text-caption text-muted">${totalRombel} Kelas</span>
      </div>
      <div style="display: flex; flex-direction: column; gap: 8px;">
        ${rombelSet.map(c => {
          const count = studentsData.filter(s => s.class === c).length;
          return `
            <div class="student-item" onclick="selectClientFilterClassDirect('${c}')" style="cursor:pointer; padding:12px;" title="Klik untuk lihat data kelas ${c}">
              <div class="student-avatar" style="background:var(--color-primary-light); color:var(--color-primary); width:40px; height:40px; border-radius:10px;">
                <i data-lucide="book-open" class="icon-sm"></i>
              </div>
              <div class="student-details">
                <div class="student-name">Kelas ${c}</div>
                <div class="student-subinfo">${count} Siswa Terdaftar</div>
              </div>
              <i data-lucide="chevron-right" class="icon-sm" style="color:var(--color-text-muted);"></i>
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
  const summaryBox = document.getElementById('clientActiveFilterSummary');
  const badgeEl = document.getElementById('badgeFilterCountClient');
  if (!container) return;

  // Active filter count
  let activeCount = 0;
  if (clientFilterClass !== 'all') activeCount++;
  if (clientFilterGender !== 'all') activeCount++;
  if (clientFilterStatus !== 'all') activeCount++;

  if (badgeEl) {
    if (activeCount > 0) {
      badgeEl.innerText = activeCount;
      badgeEl.style.display = 'inline-block';
    } else {
      badgeEl.style.display = 'none';
    }
  }

  if (summaryBox) {
    if (activeCount > 0) {
      const pills = [
        clientFilterClass !== 'all' ? `Kelas ${clientFilterClass}` : null,
        clientFilterGender !== 'all' ? clientFilterGender : null,
        clientFilterStatus !== 'all' ? `Status ${clientFilterStatus}` : null
      ].filter(Boolean);

      summaryBox.style.display = 'block';
      summaryBox.innerHTML = `
        <div style="display:flex; align-items:center; gap:6px; flex-wrap:wrap; font-size:11px; padding:6px 10px; background:var(--color-surface-subtle); border-radius:var(--radius-sm); border:1px solid var(--color-border);">
          <span style="color:var(--color-text-muted); font-weight:500;">Filter:</span>
          ${pills.map(p => `<span class="badge badge-primary" style="font-size:10px;">${p}</span>`).join('')}
          <button type="button" class="btn btn-secondary btn-sm" onclick="resetBottomSheetFiltersFor('client')" style="padding:1px 6px; font-size:10px; margin-left:auto; height:auto; min-height:0;">
            <i data-lucide="x" class="icon-sm"></i> Reset
          </button>
        </div>
      `;
    } else {
      summaryBox.style.display = 'none';
    }
  }

  if (currentScreenState !== 'loaded') {
    container.innerHTML = buildStateUI(currentScreenState);
    return;
  }

  const clientFiltered = studentsData.filter(s => {
    const matchSearch = s.name.toLowerCase().includes(clientSearchQuery) || s.nis.includes(clientSearchQuery);
    const matchClass = clientFilterClass === 'all' || s.class === clientFilterClass;
    const matchGender = clientFilterGender === 'all' || s.gender === clientFilterGender;
    const matchStatus = clientFilterStatus === 'all' || (s.status || 'Aktif') === clientFilterStatus;
    return matchSearch && matchClass && matchGender && matchStatus;
  });

  if (clientFiltered.length === 0) {
    container.innerHTML = `
      <div class="state-container">
        <div class="state-icon-box"><i data-lucide="search-x" class="icon-lg"></i></div>
        <div class="state-title">Siswa Tidak Ditemukan</div>
        <div class="state-desc">Coba atur ulang filter atau kata kunci kamu.</div>
      </div>`;
  } else {
    container.innerHTML = `
      <div class="text-caption text-muted" style="margin-bottom: 8px;">Menampilkan <strong>${clientFiltered.length}</strong> dari ${studentsData.length} siswa</div>
      <div style="display:flex; flex-direction:column; gap:8px;">` + 
      clientFiltered.map(s => `
        <div class="student-item" onclick="openDetailModal(${s.id})" style="cursor:pointer; padding:12px; display:flex; align-items:center; gap:12px; background:var(--color-surface); border:1px solid var(--color-border); border-radius:var(--radius-md);" title="Klik untuk lihat detail">
          <div class="student-avatar" style="width:40px; height:40px; font-size:15px; border-radius:10px; flex-shrink:0;">${s.name.charAt(0)}</div>
          
          <div style="flex:1; min-width:0; display:flex; flex-direction:column; gap:4px;">
            <div style="display:flex; align-items:center; justify-content:space-between; gap:6px;">
              <div class="student-name" style="font-size:14px; font-weight:600; color:var(--color-text); white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">${s.name}</div>
              <span class="badge badge-secondary" style="font-size:10px; flex-shrink:0;">${s.class}</span>
            </div>
            
            <div style="display:flex; align-items:center; gap:6px; font-size:11px; color:var(--color-text-muted);">
              <span>NIS: <strong>${s.nis}</strong></span>
              <span>•</span>
              <span>${s.gender}</span>
            </div>
          </div>

          <i data-lucide="chevron-right" class="icon-sm" style="color:var(--color-text-muted); flex-shrink:0;"></i>
        </div>
      `).join('') + `</div>`;
  }
}

// S04 — Admin Dashboard (Clean Executive Analytics & Vector Icon Consistency)
function renderS04() {
  const container = document.getElementById('adminDashboardScrollContainer');
  if (!container) return;

  if (currentScreenState !== 'loaded') {
    container.innerHTML = buildStateUI(currentScreenState);
    return;
  }

  const totalSiswa = studentsData.length;
  const rombelSet = [...new Set(studentsData.map(s => s.class))];
  const totalRombel = rombelSet.length;
  const countL = studentsData.filter(s => s.gender === 'Laki-laki').length;
  const countP = studentsData.filter(s => s.gender === 'Perempuan').length;
  const countAktif = studentsData.filter(s => (s.status || 'Aktif') === 'Aktif').length;
  const percentL = totalSiswa ? Math.round((countL / totalSiswa) * 100) : 50;
  const percentP = totalSiswa ? (100 - percentL) : 50;

  container.innerHTML = `
    <!-- Top Greeting & Academic Year Banner -->
    <div style="display:flex; justify-content:space-between; align-items:center;">
      <div>
        <h3 style="font-size:15px; font-weight:700; color:var(--color-text);">Halo, Administrator</h3>
        <p class="text-caption text-muted" style="font-size:11px;">T.A. ${schoolProfile.academicYear} • ${schoolProfile.semester}</p>
      </div>
      <span class="badge badge-primary" style="font-size:10px;">${schoolProfile.name}</span>
    </div>

    <!-- Hero Main KPI Card -->
    <div class="card-base" style="padding:18px; background:var(--color-surface); border:1px solid var(--color-border); border-radius:var(--radius-md);">
      <div style="display:flex; justify-content:space-between; align-items:flex-start;">
        <div>
          <span class="text-caption text-muted" style="font-weight:500;">Total Siswa Terdaftar</span>
          <div style="color:var(--color-text); font-size:32px; font-weight:700; line-height:1.1; margin-top:4px;">${totalSiswa} <span style="font-size:15px; font-weight:500; color:var(--color-text-muted);">Siswa</span></div>
        </div>
        <div style="width:44px; height:44px; border-radius:12px; background:var(--color-primary-light); color:var(--color-primary); display:flex; align-items:center; justify-content:center; flex-shrink:0;">
          <i data-lucide="users" class="icon-lg"></i>
        </div>
      </div>

      <div style="margin-top:14px; display:flex; gap:6px;">
        <span class="badge badge-primary" style="font-size:10px;">${totalRombel} Rombel</span>
        <span class="badge badge-success" style="font-size:10px;">${countAktif} Siswa Aktif (${totalSiswa ? Math.round((countAktif/totalSiswa)*100) : 100}%)</span>
      </div>
    </div>

    <!-- 2x2 Key Metric Cards Grid (Pure SVG Lucide Vector Icons) -->
    <div style="display:grid; grid-template-columns:1fr 1fr; gap:10px; margin-top:4px;">
      <div class="card-base" style="padding:14px; background:var(--color-surface); border:1px solid var(--color-border);">
        <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:6px;">
          <span class="text-caption text-muted" style="font-size:11px;">Rombel / Kelas</span>
          <i data-lucide="book-open" class="icon-sm" style="color:var(--color-primary);"></i>
        </div>
        <div style="font-size:20px; font-weight:700; color:var(--color-text);">${totalRombel} <span style="font-size:11px; font-weight:400; color:var(--color-text-muted);">Kelas</span></div>
      </div>

      <div class="card-base" style="padding:14px; background:var(--color-surface); border:1px solid var(--color-border);">
        <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:6px;">
          <span class="text-caption text-muted" style="font-size:11px;">Laki-laki</span>
          <i data-lucide="user" class="icon-sm" style="color:var(--color-primary);"></i>
        </div>
        <div style="font-size:20px; font-weight:700; color:var(--color-text);">${countL} <span style="font-size:11px; font-weight:400; color:var(--color-text-muted);">Siswa</span></div>
      </div>

      <div class="card-base" style="padding:14px; background:var(--color-surface); border:1px solid var(--color-border);">
        <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:6px;">
          <span class="text-caption text-muted" style="font-size:11px;">Perempuan</span>
          <i data-lucide="user-check" class="icon-sm" style="color:#EC4899;"></i>
        </div>
        <div style="font-size:20px; font-weight:700; color:var(--color-text);">${countP} <span style="font-size:11px; font-weight:400; color:var(--color-text-muted);">Siswa</span></div>
      </div>

      <div class="card-base" style="padding:14px; background:var(--color-surface); border:1px solid var(--color-border); cursor:pointer;" onclick="openPrintModal('admin');">
        <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:6px;">
          <span class="text-caption text-muted" style="font-size:11px;">Cetak Laporan</span>
          <i data-lucide="printer" class="icon-sm" style="color:var(--color-primary);"></i>
        </div>
        <div style="font-size:13px; font-weight:600; color:var(--color-primary); display:flex; align-items:center; gap:2px;">Pratinjau <i data-lucide="chevron-right" class="icon-sm"></i></div>
      </div>
    </div>

    <!-- Gender Distribution Bar Card (Vector Icon Labels) -->
    <div class="card-base" style="padding:14px; background:var(--color-surface); border:1px solid var(--color-border); border-radius:var(--radius-md); margin-top:4px;">
      <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
        <span style="font-size:12px; font-weight:600; color:var(--color-text);">Rasio Gender Siswa</span>
        <span class="text-caption text-muted" style="font-size:11px; display:flex; align-items:center; gap:8px;">
          <span style="display:flex; align-items:center; gap:3px;"><i data-lucide="user" style="width:12px; height:12px; color:var(--color-primary);"></i> ${percentL}%</span>
          <span>•</span>
          <span style="display:flex; align-items:center; gap:3px;"><i data-lucide="user-check" style="width:12px; height:12px; color:#EC4899;"></i> ${percentP}%</span>
        </span>
      </div>
      
      <!-- Visual Ratio Progress Bar -->
      <div style="height:8px; border-radius:4px; background:var(--color-surface-subtle); display:flex; overflow:hidden;">
        <div style="width:${percentL}%; background:var(--color-primary); transition:width 0.3s ease;" title="Laki-laki ${percentL}%"></div>
        <div style="width:${percentP}%; background:#EC4899; transition:width 0.3s ease;" title="Perempuan ${percentP}%"></div>
      </div>
    </div>

    <!-- Primary Dashboard Action -->
    <div style="margin-top:4px;">
      <button type="button" class="btn btn-primary btn-full" style="padding:12px; font-weight:600; justify-content:center; gap:8px;" onclick="navTo('s05'); openAddModal();">
        <i data-lucide="user-plus" class="icon-sm"></i> Tambah Siswa Baru
      </button>
    </div>

    <!-- Bottom Status Card -->
    <div class="card-base" style="padding:12px 14px; background:var(--color-surface-subtle); border:1px solid var(--color-border); margin-top:4px;">
      <div style="display:flex; align-items:center; gap:10px;">
        <div style="width:34px; height:34px; border-radius:10px; background:var(--color-success-bg); color:var(--color-success); display:flex; align-items:center; justify-content:center; flex-shrink:0;">
          <i data-lucide="shield-check" class="icon-sm"></i>
        </div>
        <div>
          <div style="font-size:12px; font-weight:600; color:var(--color-text);">Sistem Manajemen Aktif</div>
          <div class="text-caption text-muted" style="font-size:11px;">Semua data terverifikasi & tersinkronisasi</div>
        </div>
      </div>
    </div>
  `;
}

// S05 — Admin Student Management (Primary CRUD)
function renderS05() {
  const container = document.getElementById('adminStudentListContainer');
  const summaryBox = document.getElementById('adminActiveFilterSummary');
  const badgeEl = document.getElementById('badgeFilterCountAdmin');
  if (!container) return;

  // Active filter count
  let activeCount = 0;
  if (adminFilterClass !== 'all') activeCount++;
  if (adminFilterGender !== 'all') activeCount++;
  if (adminFilterStatus !== 'all') activeCount++;

  if (badgeEl) {
    if (activeCount > 0) {
      badgeEl.innerText = activeCount;
      badgeEl.style.display = 'inline-block';
    } else {
      badgeEl.style.display = 'none';
    }
  }

  if (summaryBox) {
    if (activeCount > 0) {
      const pills = [
        adminFilterClass !== 'all' ? `Kelas ${adminFilterClass}` : null,
        adminFilterGender !== 'all' ? adminFilterGender : null,
        adminFilterStatus !== 'all' ? `Status ${adminFilterStatus}` : null
      ].filter(Boolean);

      summaryBox.style.display = 'block';
      summaryBox.innerHTML = `
        <div style="display:flex; align-items:center; gap:6px; flex-wrap:wrap; font-size:11px; padding:6px 10px; background:var(--color-surface-subtle); border-radius:var(--radius-sm); border:1px solid var(--color-border);">
          <span style="color:var(--color-text-muted); font-weight:500;">Filter:</span>
          ${pills.map(p => `<span class="badge badge-primary" style="font-size:10px;">${p}</span>`).join('')}
          <button type="button" class="btn btn-secondary btn-sm" onclick="resetBottomSheetFiltersFor('admin')" style="padding:1px 6px; font-size:10px; margin-left:auto; height:auto; min-height:0;">
            <i data-lucide="x" class="icon-sm"></i> Reset
          </button>
        </div>
      `;
    } else {
      summaryBox.style.display = 'none';
    }
  }

  if (currentScreenState !== 'loaded') {
    container.innerHTML = buildStateUI(currentScreenState);
    return;
  }

  const adminFiltered = studentsData.filter(s => {
    const matchSearch = s.name.toLowerCase().includes(adminSearchQuery) || s.nis.includes(adminSearchQuery);
    const matchClass = adminFilterClass === 'all' || s.class === adminFilterClass;
    const matchGender = adminFilterGender === 'all' || s.gender === adminFilterGender;
    const matchStatus = adminFilterStatus === 'all' || (s.status || 'Aktif') === adminFilterStatus;
    return matchSearch && matchClass && matchGender && matchStatus;
  });

  if (adminFiltered.length === 0) {
    container.innerHTML = `
      <div class="state-container">
        <div class="state-icon-box"><i data-lucide="search-x" class="icon-lg"></i></div>
        <div class="state-title">Data Tidak Ditemukan</div>
        <div class="state-desc">Coba atur ulang filter atau kata kunci kamu.</div>
      </div>`;
  } else {
    container.innerHTML = `
      <div class="text-caption text-muted" style="margin-bottom: 8px;">Menampilkan <strong>${adminFiltered.length}</strong> dari ${studentsData.length} siswa</div>
      <div style="display:flex; flex-direction:column; gap:8px;">` + 
      adminFiltered.map(s => `
        <div class="student-item" onclick="openDetailModal(${s.id})" style="cursor:pointer; padding:12px; display:flex; align-items:center; gap:12px; background:var(--color-surface); border:1px solid var(--color-border); border-radius:var(--radius-md);" title="Klik untuk lihat detail">
          <div class="student-avatar" style="width:40px; height:40px; font-size:15px; border-radius:10px; flex-shrink:0;">${s.name.charAt(0)}</div>
          
          <div style="flex:1; min-width:0; display:flex; flex-direction:column; gap:4px;">
            <div style="display:flex; align-items:center; justify-content:space-between; gap:6px;">
              <div class="student-name" style="font-size:14px; font-weight:600; color:var(--color-text); white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">${s.name}</div>
              <span class="badge badge-secondary" style="font-size:10px; flex-shrink:0;">${s.class}</span>
            </div>
            
            <div style="display:flex; align-items:center; gap:6px; font-size:11px; color:var(--color-text-muted);">
              <span>NIS: <strong>${s.nis}</strong></span>
              <span>•</span>
              <span>${s.gender}</span>
            </div>
          </div>

          <div class="student-actions" onclick="event.stopPropagation()" style="display:flex; gap:4px; flex-shrink:0;">
            <button type="button" class="btn-action-icon" onclick="openEditModal(${s.id})" aria-label="Edit Siswa" title="Edit Data"><i data-lucide="edit-2"></i></button>
            <button type="button" class="btn-action-icon btn-action-delete" onclick="openDeleteDialog('${s.name.replace(/'/g, "\\'")}', '${s.nis.replace(/'/g, "\\'")}', ${s.id})" aria-label="Hapus Siswa" title="Hapus Data"><i data-lucide="trash-2"></i></button>
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
  
  // Additional student fields matching S12 detail
  if (document.getElementById('inputBirthDate')) document.getElementById('inputBirthDate').value = "";
  if (document.getElementById('selectReligion')) document.getElementById('selectReligion').value = "Islam";
  if (document.getElementById('inputGuardianName')) document.getElementById('inputGuardianName').value = "";
  if (document.getElementById('inputGuardianPhone')) document.getElementById('inputGuardianPhone').value = "";
  if (document.getElementById('selectStatus')) document.getElementById('selectStatus').value = "Aktif";
  if (document.getElementById('inputAddress')) document.getElementById('inputAddress').value = "";

  clearValidationErrors();
  openModal('studentFormModal');
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

  // Populate all additional fields
  if (document.getElementById('inputBirthDate')) document.getElementById('inputBirthDate').value = student.birthDate || "";
  if (document.getElementById('selectReligion')) document.getElementById('selectReligion').value = student.religion || "Islam";
  if (document.getElementById('inputGuardianName')) document.getElementById('inputGuardianName').value = student.guardianName || "";
  if (document.getElementById('inputGuardianPhone')) document.getElementById('inputGuardianPhone').value = student.guardianPhone || "";
  if (document.getElementById('selectStatus')) document.getElementById('selectStatus').value = student.status || "Aktif";
  if (document.getElementById('inputAddress')) document.getElementById('inputAddress').value = student.address || "";

  clearValidationErrors();
  openModal('studentFormModal');
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

  const birthDate = (document.getElementById('inputBirthDate') && document.getElementById('inputBirthDate').value.trim()) || "";
  const religion = (document.getElementById('selectReligion') && document.getElementById('selectReligion').value) || "Islam";
  const guardianName = (document.getElementById('inputGuardianName') && document.getElementById('inputGuardianName').value.trim()) || "";
  const guardianPhone = (document.getElementById('inputGuardianPhone') && document.getElementById('inputGuardianPhone').value.trim()) || "";
  const status = (document.getElementById('selectStatus') && document.getElementById('selectStatus').value) || "Aktif";
  const address = document.getElementById('inputAddress').value.trim();

  let hasError = false;
  if (!name) { showFieldError('inputName', 'errorName', 'Nama lengkap harus diisi'); hasError = true; }
  if (!nis) { showFieldError('inputNIS', 'errorNIS', 'NIS harus diisi angka'); hasError = true; }
  else if (!/^\d+$/.test(nis)) { showFieldError('inputNIS', 'errorNIS', 'NIS harus diisi angka'); hasError = true; }
  if (!className) { showFieldError('selectClass', 'errorClass', 'Pilih kelas terlebih dahulu'); hasError = true; }
  if (!birthDate) { showToast("Tanggal lahir wajib diisi", "danger"); hasError = true; }
  if (!guardianName) { showToast("Nama wali/ortu wajib diisi", "danger"); hasError = true; }
  if (!guardianPhone) { showToast("Nomor telepon wali wajib diisi", "danger"); hasError = true; }
  if (!address) { showToast("Alamat lengkap wajib diisi", "danger"); hasError = true; }

  if (hasError) return;

  setLoadingState('btnSaveStudent', true);

  setTimeout(() => {
    setLoadingState('btnSaveStudent', false);
    const studentObj = {
      id: id ? parseInt(id) : Date.now(),
      name,
      nis,
      class: className,
      gender,
      birthDate,
      religion,
      guardianName,
      guardianPhone,
      status,
      address
    };

    if (id) {
      const index = studentsData.findIndex(s => s.id == id);
      if (index !== -1) {
        studentsData[index] = studentObj;
        showToast("Data siswa berhasil diperbarui");
      }
    } else {
      studentsData.unshift(studentObj);
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

function openModal(modalId) {
  const overlay = document.getElementById('modalOverlay');
  if (overlay) overlay.classList.add('active');

  // Close all active cards first
  document.querySelectorAll('.modal-card, .dialog-card').forEach(card => card.classList.remove('active'));

  const target = document.getElementById(modalId);
  if (target) target.classList.add('active');

  refreshLucideIcons();
}

function closeModal(modalId) {
  const el = document.getElementById(modalId);
  if (el) el.classList.remove('active');
  
  const activeCard = document.querySelector('.modal-card.active, .dialog-card.active');
  if (!activeCard) {
    const overlay = document.getElementById('modalOverlay');
    if (overlay) overlay.classList.remove('active');
    highlightTab(activeScreen);
  }
}

function closeAllModals() {
  document.querySelectorAll('.modal-card, .dialog-card').forEach(card => card.classList.remove('active'));
  const overlay = document.getElementById('modalOverlay');
  if (overlay) overlay.classList.remove('active');
  highlightTab(activeScreen);
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
  renderSchoolProfileCard();
}

function renderSchoolProfileCard() {
  const container = document.getElementById('schoolProfileDisplayCard');
  if (!container) return;

  container.innerHTML = `
    <div style="display:flex; align-items:flex-start; justify-content:space-between; gap:10px;">
      <div>
        <h4 style="font-size:15px; font-weight:700; color:var(--color-text); margin:0;">${schoolProfile.name}</h4>
        <p style="font-size:11px; color:var(--color-text-muted); margin-top:2px;">NPSN: <strong>${schoolProfile.npsn}</strong></p>
      </div>
      <div style="display:flex; flex-direction:column; align-items:flex-end; gap:4px;">
        <span class="badge badge-primary" style="font-size:10px;">Terverifikasi</span>
        <span class="badge badge-secondary" style="font-size:10px;">T.A. ${schoolProfile.academicYear} (${schoolProfile.semester})</span>
      </div>
    </div>

    <div style="margin-top:10px; display:flex; flex-direction:column; gap:6px; font-size:12px; border-top:1px solid var(--color-border); padding-top:8px;">
      <div style="display:flex; align-items:center; gap:6px; color:var(--color-text);">
        <i data-lucide="map-pin" class="icon-sm" style="color:var(--color-primary);"></i>
        <span>${schoolProfile.address}</span>
      </div>
      <div style="display:flex; align-items:center; gap:6px; color:var(--color-text);">
        <i data-lucide="phone" class="icon-sm" style="color:var(--color-primary);"></i>
        <span>${schoolProfile.phone} • ${schoolProfile.email}</span>
      </div>
      <div style="display:flex; align-items:center; gap:6px; color:var(--color-text); margin-top:2px;">
        <i data-lucide="user-check" class="icon-sm" style="color:var(--color-primary);"></i>
        <span>Kepala Sekolah: <strong>${schoolProfile.principalName}</strong> (NIP. ${schoolProfile.principalNip})</span>
      </div>
    </div>
  `;
  refreshLucideIcons();
}

function openSchoolProfileModal() {
  if (!checkStatePermission()) return;

  document.getElementById('inputSchoolName').value = schoolProfile.name || '';
  document.getElementById('inputSchoolAddress').value = schoolProfile.address || '';
  document.getElementById('inputSchoolPhone').value = schoolProfile.phone || '';
  document.getElementById('inputSchoolEmail').value = schoolProfile.email || '';
  document.getElementById('inputAcademicYear').value = schoolProfile.academicYear || '2025/2026';
  document.getElementById('inputSemester').value = schoolProfile.semester || 'Semester Genap';
  document.getElementById('inputPrincipalName').value = schoolProfile.principalName || '';
  document.getElementById('inputPrincipalNIP').value = schoolProfile.principalNip || '';

  openModal('schoolProfileModal');
  highlightTab('s14');
}

function handleSchoolProfileSubmit(e) {
  e.preventDefault();
  if (!checkStatePermission()) return;

  const name = document.getElementById('inputSchoolName').value.trim();
  if (!name) {
    showToast("Nama sekolah wajib diisi", "error");
    return;
  }

  schoolProfile.name = name;
  schoolProfile.address = document.getElementById('inputSchoolAddress').value.trim() || schoolProfile.address;
  schoolProfile.phone = document.getElementById('inputSchoolPhone').value.trim() || schoolProfile.phone;
  schoolProfile.email = document.getElementById('inputSchoolEmail').value.trim() || schoolProfile.email;
  schoolProfile.academicYear = document.getElementById('inputAcademicYear').value.trim() || schoolProfile.academicYear;
  schoolProfile.semester = document.getElementById('inputSemester').value || schoolProfile.semester;
  schoolProfile.principalName = document.getElementById('inputPrincipalName').value.trim() || schoolProfile.principalName;
  schoolProfile.principalNip = document.getElementById('inputPrincipalNIP').value.trim() || schoolProfile.principalNip;

  showToast("Identitas & Tahun Ajaran berhasil diperbarui!");
  closeModal('schoolProfileModal');
  renderSchoolProfileCard();
  renderS04();
  renderS02();
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

function togglePresentationPanel(forceState = null) {
  const panel = document.getElementById('presentationPanel');
  const btn = document.getElementById('togglePanelBtn');
  const label = document.getElementById('togglePanelLabel');
  const icon = document.getElementById('togglePanelIcon');
  if (!panel) return;

  let isCollapsed;
  if (forceState !== null) {
    isCollapsed = forceState;
    panel.classList.toggle('collapsed', isCollapsed);
  } else {
    isCollapsed = panel.classList.toggle('collapsed');
  }

  localStorage.setItem('panel-collapsed', isCollapsed ? 'true' : 'false');

  if (btn) btn.classList.toggle('active', !isCollapsed);
  if (label) label.innerText = isCollapsed ? 'Panel: Tutup' : 'Panel: Tampil';
  if (icon) icon.setAttribute('data-lucide', isCollapsed ? 'layout-sidebar-off' : 'layout-sidebar');

  if (forceState === null) {
    showToast(isCollapsed ? "Panel Presentasi Ditutup" : "Panel Presentasi Tampil");
  }
  refreshLucideIcons();
}

/* ==========================================================================
   S12: DETAIL SISWA (READ-ONLY) & PRINT PREVIEW LOGIC
   ========================================================================== */
function openDetailModal(studentId) {
  const student = studentsData.find(s => s.id === studentId) || studentsData[0];
  if (!student) return;

  const content = document.getElementById('studentDetailContent');
  if (!content) return;

  content.innerHTML = `
    <!-- Top Hero Profile Header Card -->
    <div style="display:flex; flex-direction:column; align-items:center; text-align:center; padding:14px; background:var(--color-surface-subtle); border-radius:var(--radius-md); border:1px solid var(--color-border); margin-bottom:12px;">
      <div class="student-avatar" style="width:64px; height:64px; font-size:24px; margin-bottom:8px; background:var(--color-primary); color:#FFFFFF; font-weight:700; border-radius:16px; box-shadow:0 4px 12px rgba(37,99,235,0.3);">
        ${student.name.charAt(0)}
      </div>
      <h3 style="font-size:17px; font-weight:700; color:var(--color-text);">${student.name}</h3>
      <div style="font-size:12px; color:var(--color-text-muted); margin-top:2px;">NIS: <strong style="color:var(--color-primary);">${student.nis}</strong></div>
      <div style="display:flex; gap:6px; margin-top:10px; flex-wrap:wrap; justify-content:center;">
        <span class="badge badge-primary" style="font-size:11px; padding:3px 8px;">Kelas ${student.class}</span>
        <span class="badge badge-secondary" style="font-size:11px; padding:3px 8px;">${student.gender}</span>
        <span class="badge ${student.status === 'Alumni' ? 'badge-secondary' : 'badge-success'}" style="font-size:11px; padding:3px 8px;">${student.status || 'Siswa Aktif'}</span>
      </div>
    </div>

    <!-- High-Contrast Detail Info Rows -->
    <div style="display:flex; flex-direction:column; gap:8px;">
      <div class="detail-row">
        <span class="detail-label"><i data-lucide="calendar" class="icon-sm"></i> Tanggal Lahir</span>
        <span class="detail-value">${student.birthDate || '15 Mei 2007'}</span>
      </div>
      <div class="detail-row">
        <span class="detail-label"><i data-lucide="book" class="icon-sm"></i> Agama</span>
        <span class="detail-value">${student.religion || 'Islam'}</span>
      </div>
      <div class="detail-row">
        <span class="detail-label"><i data-lucide="map-pin" class="icon-sm"></i> Alamat Rumah</span>
        <span class="detail-value">${student.address || 'Jl. Sudirman No. 10'}</span>
      </div>
      <div class="detail-row">
        <span class="detail-label"><i data-lucide="user" class="icon-sm"></i> Wali Siswa</span>
        <span class="detail-value">${student.guardianName || 'Orang Tua / Wali'}</span>
      </div>
      <div class="detail-row">
        <span class="detail-label"><i data-lucide="phone" class="icon-sm"></i> Kontak Wali</span>
        <span class="detail-value">${student.guardianPhone || '0812-3456-7890'}</span>
      </div>
    </div>
  `;

  openModal('studentDetailModal');
  highlightTab('s12');
  refreshLucideIcons();
}

function openPrintModal(role = 'admin') {
  const isClient = role === 'client';
  const query = isClient ? clientSearchQuery : adminSearchQuery;
  const filterClass = isClient ? clientFilterClass : adminFilterClass;
  const filterGender = isClient ? clientFilterGender : adminFilterGender;

  const filteredData = studentsData.filter(s => {
    const matchSearch = s.name.toLowerCase().includes(query) || s.nis.includes(query);
    const matchClass = filterClass === 'all' || s.class === filterClass;
    const matchGender = filterGender === 'all' || s.gender === filterGender;
    return matchSearch && matchClass && matchGender;
  });

  const classText = filterClass === 'all' ? 'Semua Kelas' : `Kelas ${filterClass}`;
  const genderText = filterGender === 'all' ? 'Semua Gender' : filterGender;
  const activeFilters = `${classText} • ${genderText}${query ? ` • Search: "${query}"` : ''}`;

  const now = new Date();
  const dateStr = `${now.getDate()} ${['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'][now.getMonth()]} ${now.getFullYear()}`;

  const body = document.getElementById('printPreviewBody');
  if (!body) return;

  body.innerHTML = `
    <div id="printReportPaper" style="background:#fff; color:#0f172a; padding:16px; border-radius:6px; border:1px solid #cbd5e1; font-family:system-ui, sans-serif; box-sizing:border-box; width:100%; max-width:100%; overflow:hidden;">
      <div style="border-bottom: 2px solid #0F172A; padding-bottom: 8px; margin-bottom: 12px; text-align: center;">
        <h2 style="font-size: 14px; font-weight: 700; margin: 0; color: #0F172A; text-transform: uppercase; word-break:break-word;">SEKOLAHKU — ${schoolProfile.name.toUpperCase()}</h2>
        <div style="font-size: 11px; color: #475569; margin-top:2px;">${schoolProfile.address} • Telp: ${schoolProfile.phone}</div>
        <div style="font-size: 11px; font-weight:600; color: #0F172A; margin-top:2px;">Laporan Data Siswa • T.A. ${schoolProfile.academicYear} (${schoolProfile.semester})</div>
        <div style="font-size: 10px; color: #64748B; margin-top: 6px; padding: 4px 8px; background: #F1F5F9; border-radius: 4px; display: block; word-break:break-word; text-align:center;">
          Tgl Cetak: <strong>${dateStr}</strong> | Filter: <strong>${activeFilters}</strong>
        </div>
      </div>

      <div style="width:100%; overflow-x:auto;">
        <table style="width: 100%; min-width:340px; border-collapse: collapse; font-size: 11px; text-align: left; margin-top: 4px;">
          <thead>
            <tr style="background: #F1F5F9; border-bottom: 2px solid #CBD5E1;">
              <th style="padding: 6px 8px; white-space:nowrap;">No</th>
              <th style="padding: 6px 8px; white-space:nowrap;">NIS</th>
              <th style="padding: 6px 8px; white-space:nowrap;">Nama Lengkap</th>
              <th style="padding: 6px 8px; white-space:nowrap;">Kelas</th>
              <th style="padding: 6px 8px; white-space:nowrap;">Gender</th>
            </tr>
          </thead>
          <tbody>
            ${filteredData.length === 0 ? `
              <tr>
                <td colspan="5" style="padding: 16px; text-align: center; color: #94A3B8;">Tidak ada data siswa yang sesuai dengan filter.</td>
              </tr>
            ` : filteredData.map((s, idx) => `
              <tr style="border-bottom: 1px solid #E2E8F0;">
                <td style="padding: 6px 8px; white-space:nowrap;">${idx + 1}</td>
                <td style="padding: 6px 8px; white-space:nowrap;">${s.nis}</td>
                <td style="padding: 6px 8px; font-weight: 600; white-space:nowrap;">${s.name}</td>
                <td style="padding: 6px 8px; white-space:nowrap;">${s.class}</td>
                <td style="padding: 6px 8px; white-space:nowrap;">${s.gender}</td>
              </tr>
            `).join('')}
          </tbody>
        </table>
      </div>

      <div style="margin-top: 14px; font-size: 10px; color: #64748B; display: flex; justify-content: space-between; border-top: 1px solid #E2E8F0; padding-top: 8px; flex-wrap:wrap; gap:4px;">
        <span>Total Ter-filter: <strong>${filteredData.length} Siswa</strong></span>
        <span>Operator: <strong>${currentRole.toUpperCase()}</strong></span>
      </div>

      <!-- Dynamic Principal Signature Block -->
      <div style="margin-top: 20px; display: flex; justify-content: flex-end; font-size: 11px; color: #0F172A;">
        <div style="text-align: center; min-width: 180px;">
          <div>Bogor, ${dateStr}</div>
          <div>Mengetahui,</div>
          <div style="font-weight: 600; margin-top:2px;">Kepala ${schoolProfile.name}</div>
          <div style="height: 38px;"></div>
          <div style="font-weight: 700; text-decoration: underline;">${schoolProfile.principalName}</div>
          <div style="font-size: 10px; color: #64748B;">NIP. ${schoolProfile.principalNip}</div>
        </div>
      </div>
    </div>
  `;

  openModal('printPreviewModal');
  highlightTab('s13');
}

function triggerPrint() {
  const paperContent = document.getElementById('printReportPaper');
  if (!paperContent) return;

  // Try popup print window first for clean printable view
  try {
    const printWin = window.open('', '_blank', 'width=800,height=600');
    if (printWin) {
      printWin.document.write(`
        <!DOCTYPE html>
        <html>
        <head>
          <title>Laporan Data Siswa Terfilter - SekolahKu</title>
          <style>
            body { font-family: system-ui, -apple-system, sans-serif; padding: 24px; color: #0f172a; margin: 0; background: #fff; }
            table { width: 100%; border-collapse: collapse; margin-top: 12px; }
            th, td { border: 1px solid #cbd5e1; padding: 8px 12px; font-size: 12px; text-align: left; }
            th { background-color: #f1f5f9; font-weight: 700; }
            @media print {
              body { padding: 0; }
            }
          </style>
        </head>
        <body>
          ${paperContent.innerHTML}
          <script>
            window.onload = function() {
              window.print();
              setTimeout(function() { window.close(); }, 500);
            };
          </script>
        </body>
        </html>
      `);
      printWin.document.close();
      closeModal('printPreviewModal');
      showToast("Membuka dokumen cetak terfilter...");
      return;
    }
  } catch (e) {
    console.warn("Print popup failed, falling back to window.print()", e);
  }

  // Fallback to inline window.print
  const printableArea = document.getElementById('printablePaperArea');
  if (printableArea) {
    printableArea.innerHTML = paperContent.innerHTML;
  }
  
  closeModal('printPreviewModal');
  showToast("Membuka dialog cetak...");
}

// Auto scroll-into-view on mobile input focus
document.addEventListener('focusin', function (e) {
  if (e.target && (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA' || e.target.tagName === 'SELECT')) {
    setTimeout(function() {
      e.target.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }, 200);
  }
});
  setTimeout(() => {
    window.print();
  }, 300);
}
