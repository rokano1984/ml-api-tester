classdef APICallHistoryModel < handle
    properties (Access=private)
        historyList = containers.Map('KeyType','char','ValueType','any');
        selectedIdx = 0;
        PERSIST_FILENAME = fullfile(".","APICallHistory.mat");
    end
    
    events (NotifyAccess = private, ListenAccess = public)
        % Event broadcast when historyList property is changed
        historyListChanged
    end

    methods (Access=public)
        % Constructor
        function obj = APICallHistoryModel()
            % Load from default file
            obj.loadHistoryFromFile(obj.PERSIST_FILENAME);
        end
        
        function loadHistoryFromFile(obj,fname)
            if exist(fname,"file") ~= 0
                % Load data from given file
                load(fname,"historyList");
                obj.historyList = historyList;
                obj.persist();
                obj.notify("historyListChanged");
            end            
        end
        function persist(obj)
            % Save data to file
            historyList = obj.historyList;
            save(obj.PERSIST_FILENAME,"historyList");
        end
        function addHistory(obj,key,info)
            % Add new history
            obj.historyList = [obj.historyList; containers.Map(key,info)];
            obj.persist();
            obj.notify("historyListChanged");
        end
        function removeHistory(obj,key)
            % Remove history for given key
            obj.historyList.remove(key);
            obj.persist();
            obj.notify("historyListChanged");
        end
        function removeAllHistory(obj)
            % Remove all entries in historyList
            obj.historyList.remove(obj.historyList.keys);
            obj.persist();
            obj.notify("historyListChanged");
        end
        function history = findHistory(obj,key)
            % Find history for given key
            history = obj.historyList(key);
        end        
        function historyList = listAllHistory(obj)
            % List up all entries in historyList
            historyList = obj.historyList;
        end
        function setSelectedIdx(obj,idx)
            % Set selectedIdx. This is to remove particular entry in
            % historyList that user selected
            obj.selectedIdx = idx;
        end
        function selectedIdx = getSelectedIdx(obj)
            % Get selectedIdx. This is to remove particular entry in
            % historyList that user selected
            selectedIdx = obj.selectedIdx;
        end
    end
end
