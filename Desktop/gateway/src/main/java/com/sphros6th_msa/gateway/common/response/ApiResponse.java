package com.sphros6th_msa.gateway.common.response;

import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import lombok.AllArgsConstructor;
import lombok.Getter;

@JsonPropertyOrder({
        "status", "code", "message"
})
@Getter
@AllArgsConstructor
public class ApiResponse<T> {

    private Integer status;
    private Integer code;
    private String message;

}
