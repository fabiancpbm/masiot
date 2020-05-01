package br.pro.turing.masiot.core.service;

import br.pro.turing.masiot.core.model.Device;
import br.pro.turing.masiot.core.repository.DeviceRepository;
import org.bson.types.ObjectId;

/**
 * Singleton Device service.
 */
public class DeviceService {

    /** Singleton instance. */
    private static DeviceService instance;

    /** Device repository. */
    private DeviceRepository deviceRepository;

    /**
     * Constructor.
     */
    private DeviceService() {
        this.deviceRepository = DeviceRepository.getInstance();
    }

    /**
     * @return {@link #instance}
     */
    public static DeviceService getInstance() {
        if (DeviceService.instance == null) {
            DeviceService.instance = new DeviceService();
        }
        return instance;
    }

    /**
     * Save a device.
     *
     * @param device Device.
     * @return Device saved.
     */
    public Device save(Device device) {
        return this.deviceRepository.save(device);
    }

    /**
     * Find Device bu deviceName.
     *
     * @param deviceName Device name.
     * @return Device found.
     */
    public Device findByDeviceName(String deviceName) {
        return this.deviceRepository.findByDeviceName(deviceName);
    }

    /**
     * Find device by command ID.
     *
     * @param commandId Command ID.
     * @return Device found.
     */
    public Device findByCommandId(ObjectId commandId) {
        return this.deviceRepository.findByCommandId(commandId);
    }
}
