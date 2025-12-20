import React from 'react';
import { InventoryItem } from '../types';
import { AlertTriangle, ArrowDown, ArrowUp } from 'lucide-react';
import { showSuccess, showError, showWarning } from '../src/utils/toast';

const Inventory: React.FC = () => {
  const [items, setItems] = React.useState<any[]>([]);
  const [loading, setLoading] = React.useState(false);
  const [showRestock, setShowRestock] = React.useState(false);
  const [showAddMedicine, setShowAddMedicine] = React.useState(false);
  const [restockForm, setRestockForm] = React.useState({ medicine_id: '', amount: 0 });
  const [medicineForm, setMedicineForm] = React.useState({ medicine_name: '', producer: '', medicine_unit: '', medicine_type: '', medicine_administration_method: '' });
  const [medicineTypes, setMedicineTypes] = React.useState<any[]>([]);
  const [medicineAdminMethods, setMedicineAdminMethods] = React.useState<any[]>([]);

  React.useEffect(() => {
    let mounted = true;
    setLoading(true);
    import('../src/api').then(async (api) => {
      try {
        const [medsResp, stockResp, typesResp, adminResp] = await Promise.all([
          api.fetchMedicines(),
          api.fetchMedicineStock(),
          api.fetchMedicineTypes(),
          api.fetchMedicineAdminMethods()
        ]);
        const meds = medsResp.results || medsResp;
        const stock = stockResp.results || stockResp;
        const types = typesResp.results || typesResp;
        const adminMethods = adminResp.results || adminResp;

        // Aggregate stock per medicine id
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
        if (!mounted) return;
        setItems(normalized);
        setMedicineTypes(types);
        setMedicineAdminMethods(adminMethods);
        setLoading(false);
      } catch (err) {
        console.error('Failed to fetch inventory:', err);
        setLoading(false);
      }
    });
    return () => { mounted = false; };
  }, []);

  const handleOpenRestock = () => setShowRestock(true);
  const handleCloseRestock = () => {
    setShowRestock(false);
    setRestockForm({ medicine_id: '', amount: 0 });
  };

  const handleOpenAddMedicine = () => setShowAddMedicine(true);
  const handleCloseAddMedicine = () => {
    setShowAddMedicine(false);
    setMedicineForm({ medicine_name: '', producer: '', medicine_unit: '', medicine_type: '', medicine_administration_method: '' });
  };

  const handleCreateMedicine = async (ev: React.FormEvent) => {
    ev.preventDefault();

    if (!medicineForm.medicine_name) {
      return showError('Medicine name is required');
    }
    if (!medicineForm.medicine_unit) {
      return showError('Medicine unit is required');
    }
    if (!medicineForm.medicine_type) {
      return showError('Please select a medicine type');
    }
    if (!medicineForm.medicine_administration_method) {
      return showError('Please select an administration method');
    }

    setLoading(true);
    try {
      const api = await import('../src/api');
      await api.createMedicine(medicineForm);
      // refresh medicines
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
      handleCloseAddMedicine();
      showSuccess('Medicine created successfully');
    } catch (err: any) {
      showError('Create medicine failed: ' + err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleExportCSV = () => {
    if (items.length === 0) return showWarning('No data to export');

    // CSV headers
    const headers = ['ID', 'Medicine Name', 'Category', 'Current Stock', 'Unit', 'Status'];

    // CSV rows
    const rows = items.map(item => [
      item.id,
      item.name,
      item.category,
      item.stock,
      item.unit,
      item.stock < (item.minLevel || 10) ? 'Low Stock' : 'In Stock'
    ]);

    // Create CSV content
    const csvContent = [
      headers.join(','),
      ...rows.map(row => row.map(cell => `"${cell}"`).join(','))
    ].join('\n');

    // Download
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);
    link.setAttribute('href', url);
    link.setAttribute('download', `inventory_report_${new Date().toISOString().split('T')[0]}.csv`);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  const handleRestock = async (ev: React.FormEvent) => {
    ev.preventDefault();

    // Validation
    if (!restockForm.medicine_id) {
      return showError('Please select a medicine');
    }
    if (!restockForm.amount || restockForm.amount <= 0) {
      return showError('Please enter a valid amount (greater than 0)');
    }

    setLoading(true);
    try {
      const api = await import('../src/api');
      await api.createMedicineStock({ medicine: restockForm.medicine_id, add_remove: true, amount: restockForm.amount });
      // refresh
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
      setRestockForm({ medicine_id: '', amount: 0 });
      handleCloseRestock();
      showSuccess('Medicine restocked successfully');
    } catch (err:any) {
      showError('Restock failed: ' + err.message);
    } finally {
      setLoading(false);
    }
  }
  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h2 className="text-2xl font-bold text-slate-800">Pharmacy & Inventory</h2>
          <p className="text-slate-500 text-sm">Track medication stock and supplies</p>
        </div>
        <div className="flex gap-3">
          <button onClick={handleExportCSV} className="flex items-center gap-2 bg-white border border-slate-200 text-slate-700 px-4 py-2 rounded-lg text-sm font-medium hover:bg-slate-50">
            <ArrowDown className="w-4 h-4" /> Export Report
          </button>
          <button onClick={handleOpenAddMedicine} className="flex items-center gap-2 bg-green-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-green-700 shadow-sm">
            Add Medicine
          </button>
          <button onClick={handleOpenRestock} className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-blue-700 shadow-sm">
            <ArrowUp className="w-4 h-4" /> Restock Item
          </button>
        </div>
      </div>

      <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
        <table className="w-full text-left">
          <thead className="bg-slate-50 text-slate-500 text-xs uppercase font-semibold">
            <tr>
              <th className="px-6 py-4">Item Name</th>
              <th className="px-6 py-4">Category</th>
              <th className="px-6 py-4">Current Stock</th>
              <th className="px-6 py-4">Status</th>
              <th className="px-6 py-4">Last Updated</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100">
            {items.map((item: any) => {
              const isLow = item.stock < (item.minLevel || 10);
              return (
                <tr key={item.id} className="hover:bg-slate-50 transition-colors">
                  <td className="px-6 py-4">
                    <div className="font-medium text-slate-800">{item.name}</div>
                    <div className="text-xs text-slate-400 font-mono">{item.id}</div>
                  </td>
                  <td className="px-6 py-4 text-slate-600">{item.category}</td>
                  <td className="px-6 py-4">
                    <span className="font-bold text-slate-800">{item.stock}</span> 
                    <span className="text-slate-500 text-xs ml-1">{item.unit}</span>
                  </td>
                  <td className="px-6 py-4">
                    {isLow ? (
                      <span className="flex items-center gap-1 text-red-600 text-xs font-bold bg-red-50 px-2 py-1 rounded-full w-fit">
                        <AlertTriangle className="w-3 h-3" /> Low Stock
                      </span>
                    ) : (
                      <span className="text-green-600 text-xs font-bold bg-green-50 px-2 py-1 rounded-full w-fit">
                        In Stock
                      </span>
                    )}
                  </td>
                  <td className="px-6 py-4 text-slate-500 text-sm">{item.lastUpdated}</td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

      {showRestock && (
        <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50">
          <form onSubmit={handleRestock} className="bg-white p-6 rounded-xl w-full max-w-md">
            <h3 className="text-lg font-bold mb-4">Restock Item</h3>
            <select value={restockForm.medicine_id} onChange={(e)=>setRestockForm({...restockForm, medicine_id: e.target.value})} className="w-full p-2 border rounded mb-3" required>
              <option value="">Select medicine *</option>
              {items.map((m:any)=> <option key={m.id} value={m.id}>{m.name} (Current: {m.stock})</option>)}
            </select>
            <input type="number" min={1} value={restockForm.amount || ''} onChange={(e)=>setRestockForm({...restockForm, amount: parseInt(e.target.value||'0', 10)})} className="w-full p-2 border rounded mb-3" placeholder="Amount *" required />
            <div className="flex justify-end gap-2 mt-4">
              <button type="button" onClick={handleCloseRestock} className="px-4 py-2 rounded border" disabled={loading}>Cancel</button>
              <button type="submit" disabled={loading} className="px-4 py-2 rounded bg-blue-600 text-white disabled:opacity-50">{loading ? 'Restocking...' : 'Restock'}</button>
            </div>
          </form>
        </div>
      )}

      {showAddMedicine && (
        <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50">
          <form onSubmit={handleCreateMedicine} className="bg-white p-6 rounded-xl w-full max-w-md">
            <h3 className="text-lg font-bold mb-4">Add New Medicine</h3>
            <div className="grid grid-cols-1 gap-3">
              <input value={medicineForm.medicine_name} onChange={(e)=>setMedicineForm({...medicineForm, medicine_name: e.target.value})} placeholder="Medicine Name *" className="p-2 border rounded" required />
              <input value={medicineForm.producer} onChange={(e)=>setMedicineForm({...medicineForm, producer: e.target.value})} placeholder="Producer / Manufacturer" className="p-2 border rounded" />
              <input value={medicineForm.medicine_unit} onChange={(e)=>setMedicineForm({...medicineForm, medicine_unit: e.target.value})} placeholder="Unit (e.g., tablets, ml, mg) *" className="p-2 border rounded" required />
              <select value={medicineForm.medicine_type} onChange={(e)=>setMedicineForm({...medicineForm, medicine_type: e.target.value})} className="p-2 border rounded" required>
                <option value="">Select Medicine Type *</option>
                {medicineTypes.map((t:any)=> <option key={t.id} value={t.id}>{t.name}</option>)}
              </select>
              <select value={medicineForm.medicine_administration_method} onChange={(e)=>setMedicineForm({...medicineForm, medicine_administration_method: e.target.value})} className="p-2 border rounded" required>
                <option value="">Select Administration Method *</option>
                {medicineAdminMethods.map((m:any)=> <option key={m.id} value={m.id}>{m.name}</option>)}
              </select>

              <div className="flex justify-end gap-2 mt-4">
                <button type="button" onClick={handleCloseAddMedicine} className="px-4 py-2 rounded border" disabled={loading}>Cancel</button>
                <button type="submit" disabled={loading} className="px-4 py-2 rounded bg-blue-600 text-white disabled:opacity-50">{loading ? 'Creating...' : 'Create'}</button>
              </div>
            </div>
          </form>
        </div>
      )}
    </div>
  );
};

export default Inventory;