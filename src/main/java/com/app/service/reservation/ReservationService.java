package com.app.service.reservation;

import java.util.List;

import com.app.dto.reservation.Reservation;

public interface ReservationService {

	//유저코드 기반으로 예약리스트 불러오기
	public List<Reservation> findReservationListByUseCode(int userCode);
	
	//예약코드 기반으로 예약 정보 확인 후 예약상태 예약취소로 변경
	public int updateRsvtStatusByRsvtCode(String rsvtCode);
	
}
