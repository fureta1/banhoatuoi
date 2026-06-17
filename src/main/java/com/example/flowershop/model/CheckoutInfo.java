package com.example.flowershop.model;

import java.io.Serializable;

public class CheckoutInfo implements Serializable {

    private String buyerName;
    private String buyerPhone;
    private String buyerEmail;

    private String receiverName;
    private String receiverPhone;
    private String receiverAddress;
    private String cardMessage;
    private String note;

    // getter / setter
    public String getBuyerName() {
        return buyerName;
    }
    public void setBuyerName(String buyerName) {
        this.buyerName = buyerName;
    }

    public String getBuyerPhone() {
        return buyerPhone;
    }
    public void setBuyerPhone(String buyerPhone) {
        this.buyerPhone = buyerPhone;
    }

    public String getBuyerEmail() {
        return buyerEmail;
    }
    public void setBuyerEmail(String buyerEmail) {
        this.buyerEmail = buyerEmail;
    }

    public String getReceiverName() {
        return receiverName;
    }
    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getReceiverPhone() {
        return receiverPhone;
    }
    public void setReceiverPhone(String receiverPhone) {
        this.receiverPhone = receiverPhone;
    }

    public String getReceiverAddress() {
        return receiverAddress;
    }
    public void setReceiverAddress(String receiverAddress) {
        this.receiverAddress = receiverAddress;
    }

    public String getNote() {
        return note;
    }
    public void setNote(String note) {
        this.note = note;
    }
    public String getCardMessage() {
    return cardMessage;
}

public void setCardMessage(String cardMessage) {
    this.cardMessage = cardMessage;
}
}

