using Toybox.System;
import Toybox.Lang;

class SongStorage{
    var size = 5;
    var currentIndex = 0;
    var cycleBuffer = [null,null,null,null,null]; // Should probably change to LRU cache
    var bufferMap = {};
    var requestMap = [];

    public function isStored(id){
        return bufferMap.hasKey(id);
    }

    public function getStoredSong(id){
        return cycleBuffer[bufferMap.get(id)];
    }

    public function storeTransmissionData(data as TransmitData){
        currentIndex++;
        currentIndex = currentIndex % size;
        if (cycleBuffer[currentIndex] != null){
            bufferMap.remove(cycleBuffer[currentIndex]._songId);
            
        }
        
        
        cycleBuffer[currentIndex] = data;
        
        bufferMap.put(data._songId, currentIndex);
        
    }

    public function setImageToCurrentSong(bitmap){
        cycleBuffer[currentIndex].bitmap = bitmap;
    }

    public function setRequest(id){
        requestMap.add(id);
    }

    public function removeRequest(id){
        requestMap.removeAll(id);
    }

    public function isRequested(id){
        
        return requestMap.indexOf(id) != -1;
    }
}