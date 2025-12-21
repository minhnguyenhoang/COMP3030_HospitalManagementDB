# UI Update Guide - Edit/Delete Features

## ✅ Đã hoàn thành

### 1. Backend (100%)
- ✅ SQL Stored Procedures (file: `src/sql2/03_procedures_triggers_views.sql`)
  - sp_UpdatePatient, sp_UpdateDoctor, sp_UpdateAppointment, sp_UpdateMedicine
  - sp_DeletePatient, sp_DeleteDoctor, sp_DeleteAppointment, sp_DeleteMedicine

- ✅ Django API Endpoints (tất cả ViewSets đã có UPDATE/DELETE)
  - PUT `/api/patients/{id}/`
  - DELETE `/api/patients/{id}/`
  - PUT `/api/doctors/{id}/`
  - DELETE `/api/doctors/{id}/`
  - PUT `/api/appointments/{id}/`
  - DELETE `/api/appointments/{id}/`
  - PUT `/api/medicines/{id}/`
  - DELETE `/api/medicines/{id}/`

- ✅ Frontend API Service (file: `medicore-hms/src/api/index.ts`)
  - updatePatient, deletePatient
  - updateDoctor, deleteDoctor
  - updateAppointment, deleteAppointment
  - updateMedicine, deleteMedicine

### 2. Frontend UI

#### ✅ Patients.tsx - HOÀN THÀNH
- Import icons: `Pencil, Trash2`
- Added Edit/Delete buttons trong Actions column
- Edit modal với form đầy đủ
- Handlers: `handleOpenEdit`, `handleUpdate`, `handleDelete`

#### ✅ Staff.tsx - HOÀN THÀNH
- Import icons: `Pencil, Trash2`
- Replace MoreHorizontal button với Edit/Delete buttons
- Edit modal với form đầy đủ
- Handlers: `handleOpenEdit`, `handleUpdate`, `handleDelete`

## ⏳ Còn lại cần làm

### 1. Inventory.tsx - Thêm Edit/Delete cho Medicines

**Bước 1**: Đã thêm imports và states (lines 1-16)
```typescript
import { Pencil, Trash2 } from 'lucide-react';
const [showEditMedicine, setShowEditMedicine] = React.useState(false);
const [editingMedicine, setEditingMedicine] = React.useState<any>(null);
```

**Bước 2**: Cần thêm handlers sau `handleCreateMedicine` (sau dòng ~120):
```typescript
const handleOpenEdit = async (medicineId: number) => {
  setLoading(true);
  try {
    const api = await import('../src/api');
    const medsResp = await api.fetchMedicines();
    const meds = medsResp.results || medsResp;
    const medicine = meds.find((m: any) => m.id === medicineId);

    if (medicine) {
      setEditingMedicine(medicine);
      setMedicineForm({
        medicine_name: medicine.medicine_name || '',
        producer: medicine.producer || '',
        medicine_unit: medicine.medicine_unit || '',
        medicine_type: medicine.medicine_type?.id || '',
        medicine_administration_method: medicine.medicine_administration_method?.id || '',
        price: medicine.price || ''
      });
      setShowEditMedicine(true);
    }
  } catch (err: any) {
    showError('Failed to load medicine: ' + err.message);
  } finally {
    setLoading(false);
  }
};

const handleCloseEdit = () => {
  setShowEditMedicine(false);
  setEditingMedicine(null);
  setMedicineForm({ medicine_name: '', producer: '', medicine_unit: '', medicine_type: '', medicine_administration_method: '', price: '' });
};

const handleUpdate = async (ev: React.FormEvent) => {
  ev.preventDefault();
  if (!editingMedicine) return;

  setLoading(true);
  try {
    const api = await import('../src/api');
    await api.updateMedicine(editingMedicine.id, medicineForm);

    // Refresh list
    const [medsResp, stockResp] = await Promise.all([api.fetchMedicines(), api.fetchMedicineStock()]);
    const meds = medsResp.results || medsResp;
    const stock = stockResp.results || stockResp;
    const stockMap: Record<number, number> = {};
    stock.forEach((s: any) => {
      const id = s.medicine;
      const delta = s.add_remove ? s.amount : -s.amount;
      stockMap[id] = (stockMap[id] || 0) + delta;
    });

    const normalized = meds.map((m: any) => ({
      id: m.id,
      name: m.medicine_name,
      category: m.producer || 'Medication',
      stock: stockMap[m.id] || 0,
      unit: m.medicine_unit || '',
      minLevel: 10,
      lastUpdated: '—',
    }));
    setItems(normalized);

    handleCloseEdit();
    showSuccess('Medicine updated successfully');
  } catch (err: any) {
    showError('Update failed: ' + err.message);
  } finally {
    setLoading(false);
  }
};

const handleDelete = async (medicineId: number) => {
  if (!confirm('Are you sure you want to delete this medicine? This action cannot be undone.')) {
    return;
  }

  setLoading(true);
  try {
    const api = await import('../src/api');
    await api.deleteMedicine(medicineId);
    setItems(prev => prev.filter(item => item.id !== medicineId));
    showSuccess('Medicine deleted successfully');
  } catch (err: any) {
    showError('Delete failed: ' + err.message);
  } finally {
    setLoading(false);
  }
};
```

**Bước 3**: Tìm table rendering (search for `<tbody>`) và thêm Edit/Delete buttons vào Actions column:
```tsx
<td className="px-6 py-4 text-right">
  <div className="flex items-center justify-end gap-2">
    <button
      onClick={() => handleOpenRestock()} // existing
      className="text-blue-600 hover:bg-blue-50 p-2 rounded-lg"
      title="Restock"
    >
      <ArrowUp className="w-4 h-4" />
    </button>
    <button
      onClick={() => handleOpenEdit(item.id)}
      className="text-green-600 hover:bg-green-50 p-2 rounded-lg"
      title="Edit"
    >
      <Pencil className="w-4 h-4" />
    </button>
    <button
      onClick={() => handleDelete(item.id)}
      className="text-red-600 hover:bg-red-50 p-2 rounded-lg"
      title="Delete"
      disabled={loading}
    >
      <Trash2 className="w-4 h-4" />
    </button>
  </div>
</td>
```

**Bước 4**: Thêm Edit modal sau Add Medicine modal (tìm `{showAddMedicine &&` rồi thêm sau `)}` của nó):
```tsx
{/* Edit Medicine Modal */}
{showEditMedicine && editingMedicine && (
  <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50 p-4">
    <form onSubmit={handleUpdate} className="bg-white p-6 rounded-xl w-full max-w-md">
      <h3 className="text-lg font-bold mb-4">Edit Medicine</h3>
      <div className="grid grid-cols-1 gap-3">
        <input
          value={medicineForm.medicine_name}
          onChange={(e)=>setMedicineForm({...medicineForm, medicine_name: e.target.value})}
          placeholder="Medicine Name *"
          className="p-2 border rounded"
          required
        />
        <input
          value={medicineForm.producer}
          onChange={(e)=>setMedicineForm({...medicineForm, producer: e.target.value})}
          placeholder="Producer"
          className="p-2 border rounded"
        />
        <input
          value={medicineForm.medicine_unit}
          onChange={(e)=>setMedicineForm({...medicineForm, medicine_unit: e.target.value})}
          placeholder="Unit (e.g., tablet, ml) *"
          className="p-2 border rounded"
          required
        />
        <input
          type="number"
          step="0.01"
          value={medicineForm.price}
          onChange={(e)=>setMedicineForm({...medicineForm, price: e.target.value})}
          placeholder="Price"
          className="p-2 border rounded"
        />
        <select
          value={medicineForm.medicine_type}
          onChange={(e)=>setMedicineForm({...medicineForm, medicine_type: e.target.value})}
          className="p-2 border rounded"
          required
        >
          <option value="">Select Type *</option>
          {medicineTypes.map((t:any)=> <option key={t.id} value={t.id}>{t.name}</option>)}
        </select>
        <select
          value={medicineForm.medicine_administration_method}
          onChange={(e)=>setMedicineForm({...medicineForm, medicine_administration_method: e.target.value})}
          className="p-2 border rounded"
          required
        >
          <option value="">Select Administration Method *</option>
          {medicineAdminMethods.map((a:any)=> <option key={a.id} value={a.id}>{a.name}</option>)}
        </select>

        <div className="flex justify-end gap-2 mt-4">
          <button type="button" onClick={handleCloseEdit} className="px-4 py-2 rounded border">Cancel</button>
          <button type="submit" disabled={loading} className="px-4 py-2 rounded bg-blue-600 text-white disabled:opacity-50">
            {loading ? 'Updating...' : 'Update'}
          </button>
        </div>
      </div>
    </form>
  </div>
)}
```

### 2. Appointments.tsx - Thêm Delete (Optional)

File này rất phức tạp với nhiều logic khác nhau cho Doctor và Receptionist views. Đề xuất chỉ thêm **DELETE button** cho danh sách appointments.

**Tìm phần render appointments list** (dòng ~245-277 trong Today's Appointments):

Thay đổi từ:
```tsx
<button
  key={appt.id || i}
  onClick={() => setSelectedPatient(patient?.id || patient || null)}
  className="w-full text-left p-3 rounded-lg..."
>
  {/* content */}
</button>
```

Thành:
```tsx
<div key={appt.id || i} className="flex gap-2 items-center">
  <button
    onClick={() => setSelectedPatient(patient?.id || patient || null)}
    className="flex-1 text-left p-3 rounded-lg..."
  >
    <div className="font-medium">{patientName}</div>
    <div className="text-xs opacity-70 flex justify-between mt-1">
      <span>ID: {patient?.id || patient}</span>
      <span>{displayTime}</span>
    </div>
  </button>

  <button
    onClick={(e) => {
      e.stopPropagation();
      handleDeleteAppointment(appt.id);
    }}
    className="text-red-600 hover:bg-red-50 p-2 rounded transition-colors"
    title="Cancel Appointment"
  >
    <Trash2 className="w-4 h-4" />
  </button>
</div>
```

**Thêm handler function** (sau các handlers hiện có, trước return statement):
```typescript
const handleDeleteAppointment = async (appointmentId: number) => {
  if (!confirm('Are you sure you want to cancel this appointment?')) {
    return;
  }

  setLoading(true);
  try {
    const api = await import('../src/api');
    await api.deleteAppointment(appointmentId);
    setAppointments(prev => prev.filter(a => a.id !== appointmentId));
    showSuccess('Appointment cancelled successfully');
  } catch (err: any) {
    showError('Failed to cancel appointment: ' + err.message);
  } finally {
    setLoading(false);
  }
};
```

**Import icon** (dòng 2):
```typescript
import { Search, Calendar, User, FileText, CheckCircle, Trash2 } from 'lucide-react';
```

## Tổng kết

Sau khi hoàn thành 2 files trên, hệ thống sẽ có đầy đủ CRUD operations:

### Patients
- ✅ Create: Modal form
- ✅ Read: Table list + Detail page
- ✅ Update: Edit modal với full form
- ✅ Delete: Delete button với confirmation

### Staff/Doctors
- ✅ Create: Modal form
- ✅ Read: Card grid layout
- ✅ Update: Edit modal với full form
- ✅ Delete: Delete button với confirmation

### Inventory/Medicines
- ✅ Create: Modal form
- ⏳ Read: Table list
- ⏳ Update: Edit modal (cần thêm)
- ⏳ Delete: Delete button (cần thêm)

### Appointments
- ✅ Create: Multi-step form (Receptionist)
- ✅ Read: List view
- ⏳ Update: Có thể bỏ qua (quá phức tạp)
- ⏳ Delete: Cancel button (cần thêm)

## Lưu ý khi test

1. **Delete Patient/Doctor**: Sẽ fail nếu có appointments liên quan
2. **Delete Medicine**: Sẽ fail nếu đã có prescription history
3. **Delete Appointment**: Sẽ cascade delete prescriptions và stock history
4. **Update operations**: Cần validate đầy đủ required fields

## Chạy lại database setup

Sau khi cập nhật SQL procedures, cần chạy lại:
```bash
cd backend
python setup_complete.py
```
