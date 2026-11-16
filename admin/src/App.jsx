import React, { useState, useEffect } from 'react';
import Navbar from './components/Navbar';
import Sidebar from './components/Sidebar';
import StatsCards from './components/StatsCards';
import IncidentsMap from './components/IncidentsMap';
import KanbanBoard from './components/KanbanBoard';
import IncidentsTable from './components/IncidentsTable';
import CrewsView from './components/CrewsView';
import AnalyticsView from './components/AnalyticsView';
import IncidentDetailModal from './components/IncidentDetailModal';
import LiveToast from './components/LiveToast';
import { INITIAL_CATEGORIES, INITIAL_CREWS, INITIAL_REPORTS } from './data/mockData';
import { isSupabaseConfigured } from './services/supabaseClient';
import { fetchLiveReports, subscribeToLiveEvents, updateReportOnServer, playChime } from './services/liveService';

export default function App() {
  const [reports, setReports] = useState(INITIAL_REPORTS);
  const [categories, setCategories] = useState(INITIAL_CATEGORIES);
  const [crews, setCrews] = useState(INITIAL_CREWS);

  // Navigation & Filter State
  const [currentTab, setCurrentTab] = useState('map'); // 'map' | 'kanban' | 'table' | 'stats' | 'crews'
  const [selectedCategory, setSelectedCategory] = useState(null);
  const [statusFilter, setStatusFilter] = useState('all');
  const [searchQuery, setSearchQuery] = useState('');

  // Selected report for inspection modal & map focus
  const [selectedIncident, setSelectedIncident] = useState(null);
  const [focusedIncident, setFocusedIncident] = useState(null);
  const [liveToast, setLiveToast] = useState(null);

  // Sincronización en vivo con el Servidor C4 Morelia
  useEffect(() => {
    // 1. Cargar datos iniciales desde el servidor
    fetchLiveReports().then(data => {
      if (Array.isArray(data) && data.length > 0) {
        setReports(data);
      }
    });

    // 2. Escuchar stream de eventos SSE en tiempo real
    const unsubscribe = subscribeToLiveEvents((event) => {
      if (event.type === 'REPORT_CREATED') {
        const newRep = event.data;
        setReports(prev => {
          if (prev.some(r => r.id === newRep.id || r.ticketNumber === newRep.ticketNumber)) return prev;
          return [newRep, ...prev];
        });
        playChime();
        setLiveToast({ report: newRep });
      } else if (event.type === 'REPORT_UPVOTED') {
        const updated = event.data;
        setReports(prev => prev.map(r => (r.id === updated.id ? { ...r, upvotesCount: updated.upvotesCount } : r)));
      } else if (event.type === 'REPORT_STATUS_CHANGED') {
        const updated = event.data;
        setReports(prev => prev.map(r => (r.id === updated.id ? { ...r, status: updated.status, assignedCrewId: updated.assignedCrewId } : r)));
      }
    });

    return () => unsubscribe();
  }, []);

  // Handle report status change
  const handleStatusChange = (reportId, newStatus) => {
    updateReportOnServer(reportId, { status: newStatus });
    setReports(prev => prev.map(rep => {
      if (rep.id === reportId) {
        const historyEntry = {
          status: newStatus,
          date: new Date().toISOString(),
          note: `Estado actualizado a ${newStatus} por Supervisor C4 Morelia`
        };
        const updated = {
          ...rep,
          status: newStatus,
          history: [...(rep.history || []), historyEntry]
        };
        if (newStatus === 'resolved') {
          updated.resolvedAt = new Date().toISOString();
        }
        return updated;
      }
      return rep;
    }));

    // Update inspected modal if open
    if (selectedIncident && selectedIncident.id === reportId) {
      setSelectedIncident(prev => ({
        ...prev,
        status: newStatus
      }));
    }
  };

  // Handle crew assignment
  const handleAssignCrew = (reportId, crewId) => {
    updateReportOnServer(reportId, { assignedCrewId: crewId });
    setReports(prev => prev.map(rep => {
      if (rep.id === reportId) {
        const newStatus = (rep.status === 'pending' || rep.status === 'in_review') ? 'assigned' : rep.status;
        return {
          ...rep,
          assignedCrewId: crewId,
          status: newStatus
        };
      }
      return rep;
    }));

    if (selectedIncident && selectedIncident.id === reportId) {
      setSelectedIncident(prev => ({
        ...prev,
        assignedCrewId: crewId,
        status: (prev.status === 'pending' || prev.status === 'in_review') ? 'assigned' : prev.status
      }));
    }
  };

  // Filter reports according to category, status, and search query
  const filteredReports = reports.filter(r => {
    if (selectedCategory && r.categoryId !== selectedCategory) return false;
    if (statusFilter !== 'all' && r.status !== statusFilter) return false;
    if (searchQuery.trim() !== '') {
      const q = searchQuery.toLowerCase();
      const matchTicket = r.ticketNumber.toLowerCase().includes(q);
      const matchTitle = r.title.toLowerCase().includes(q);
      const matchAddress = r.address.toLowerCase().includes(q);
      const matchNeighborhood = (r.neighborhood || '').toLowerCase().includes(q);
      if (!matchTicket && !matchTitle && !matchAddress && !matchNeighborhood) return false;
    }
    return true;
  });

  const criticalCount = reports.filter(r => r.priority === 'critical' && r.status !== 'resolved').length;

  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      
      {/* Top Navigation */}
      <Navbar
        searchQuery={searchQuery}
        setSearchQuery={setSearchQuery}
        criticalCount={criticalCount}
        isMockMode={!isSupabaseConfigured}
      />

      {/* Main Container: Sidebar + Content */}
      <div style={{
        display: 'flex',
        gap: '24px',
        padding: '20px 24px 30px 24px',
        maxWidth: '1800px',
        width: '100%',
        margin: '0 auto',
        flex: 1
      }}>
        {/* Navigation Sidebar */}
        <Sidebar
          currentTab={currentTab}
          setCurrentTab={setCurrentTab}
          categories={categories}
          selectedCategory={selectedCategory}
          setSelectedCategory={setSelectedCategory}
          reports={reports}
        />

        {/* Dynamic Main Workspace */}
        <main style={{ flex: 1, minWidth: 0 }}>
          
          {/* Top High-level KPI Bar (always visible) */}
          <StatsCards reports={reports} />

          {/* Active Tab View */}
          {currentTab === 'map' && (
            <IncidentsMap
              reports={filteredReports}
              categories={categories}
              onSelectIncident={(incident) => setSelectedIncident(incident)}
              statusFilter={statusFilter}
              setStatusFilter={setStatusFilter}
              focusedIncident={focusedIncident}
            />
          )}

          {currentTab === 'kanban' && (
            <KanbanBoard
              reports={filteredReports}
              categories={categories}
              crews={crews}
              onSelectIncident={(incident) => setSelectedIncident(incident)}
              onStatusChange={handleStatusChange}
            />
          )}

          {currentTab === 'table' && (
            <IncidentsTable
              reports={filteredReports}
              categories={categories}
              crews={crews}
              onSelectIncident={(incident) => setSelectedIncident(incident)}
            />
          )}

          {currentTab === 'stats' && (
            <AnalyticsView
              reports={reports}
              categories={categories}
            />
          )}

          {currentTab === 'crews' && (
            <CrewsView
              crews={crews}
              reports={reports}
              onSelectIncident={(incident) => setSelectedIncident(incident)}
            />
          )}
        </main>
      </div>

      {/* Deep Inspection & Dispatch Modal */}
      {selectedIncident && (
        <IncidentDetailModal
          report={selectedIncident}
          categories={categories}
          crews={crews}
          onClose={() => setSelectedIncident(null)}
          onStatusChange={handleStatusChange}
          onAssignCrew={handleAssignCrew}
        />
      )}

      {/* Real-time incoming report toast */}
      <LiveToast
        toast={liveToast}
        onDismiss={() => setLiveToast(null)}
        onViewReport={(rep) => {
          setCurrentTab('map');
          setFocusedIncident(rep);
          setSelectedIncident(rep);
        }}
      />
    </div>
  );
}
