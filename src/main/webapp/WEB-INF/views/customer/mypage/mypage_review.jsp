<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MY PAGE</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
	integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" type="text/css"
	href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick.min.css" />
<link rel="stylesheet" type="text/css"
	href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick-theme.min.css" />
<link href="/css/customer/mypage_review.css" rel="stylesheet"
	type="text/css">
<script src="/js/customer/alertMsg.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
</head>
<body>
	<div id="write-review-popup" class="display-none">
		<div id="write-review-container">
			<div id="write-review-box">

				<h1>리뷰 수정</h1>

				<div id="write-review-container-cancel">
					<div id="icon-cancel">
						<i class="fa-solid fa-xmark"></i>
					</div>
				</div>

				<div id="write-review-text-container">
					<div id="write-review-info">

						<div>
							<h2 id="acm_name"></h2>
							<h4>
								<span id="reviewRating"></span> | 작성날짜 : <span id="reviewDate"></span>
							</h4>
						</div>
					</div>

					<div id="review-picture-list">

						<div>
							<h3>리뷰 이미지 목록</h3>
						</div>

						<div id="review-img"></div>

						<div>
							<h3>업로드할 이미지 목록</h3>
						</div>

						<div id="review-img-preview"></div>

					</div>

				</div>

				<div id="wirte-review-form">
					<form action="/mypage/modifyReview" method="post"
						enctype="multipart/form-data">
						<textarea id="reviewText" name="reviewText"></textarea>
						<input type="hidden" name="reviewCode" id="reviewCode">

						<div class="file-upload-container">
							<div class="file-upload-btn">
								<i class="fa-regular fa-image"></i> <span>사진 업로드</span>
							</div>
							<input type="file" name="reviewImgFile" id="fileInput"
								accept="image/*" multiple />
						</div>
						<button type="submit" class="btn-write">수정하기</button>
					</form>
				</div>
			</div>
		</div>
	</div>

	<div class="container">
		<div class="header">
			<div class="nav-top">
				<div class="nav-top-left">
					<a href="#" id="icon-btn"><img src="/img/icon1.png" /></a>
					<div class="hidenav" id="sidebar">
						<div class="hidenavcontent">
							<button id="close-btn" class="close-btn">X</button>
							<ul>
								<li><a href="#" class="category" data-target="subcategory1">카테고리
										1</a>
									<ul class="subcategories" id="subcategory1">
										<li><a href="#">하위 카테고리 1-1</a></li>
										<li><a href="#">하위 카테고리 1-2</a></li>
										<li><a href="#">하위 카테고리 1-3</a></li>
									</ul></li>
								<li><a href="#" class="category" data-target="subcategory2">카테고리
										2</a>
									<ul class="subcategories" id="subcategory2">
										<li><a href="#">하위 카테고리 2-1</a></li>
										<li><a href="#">하위 카테고리 2-2</a></li>
										<li><a href="#">하위 카테고리 2-3</a></li>
									</ul></li>
							</ul>
						</div>
					</div>
				</div>
				<div class="nav-top-center">
					<a href="/"><img src="/logo/가로로고 복사3.png"></a>
				</div>
				<div class="nav-top-right" id="success-login">
					<button id="mypage-btn" onclick="location.href='/mypage/checkPw'">${user.userNickname}</button>
					<button id="logout-btn" onclick="location.href='/userlogout'">로그아웃</button>
				</div>
			</div>
		</div>
		<div class="main">
			<div class="mypage-sidebar">
				<ul>
					<li><a href="/mypage/userInfo">회원정보 변경<i
							class="fa-solid fa-chevron-right"></i></a></li>
					<li><a href="/mypage/checkReservation/confirmed">예약 내역 <i
							class="fa-solid fa-chevron-right"></i></a></li>
					<li class="backgorundColor-gray"><a href="/mypage/review">내가
							쓴 리뷰 <i class="fa-solid fa-chevron-right"></i>
					</a></li>
					<li><a href="/mypage/useableCoupon">쿠폰함 <i
							class="fa-solid fa-chevron-right"></i></a></li>
				</ul>
			</div>

			<div class="review_content">
				<div id="review-container">
					<h1>내가 쓴 리뷰</h1>

					<c:forEach var="review" items="${reviewList}">
						<div class="review-box">
							<div class="review-text-container">
								<div>
									<h2>${review.acmName }</h2>
									<h4>
										<c:choose>
											<c:when test="${review.rating == 5}">
												<span> <span class="color-gold">&#9733;</span> <span
													class="color-gold">&#9733;</span> <span class="color-gold">&#9733;</span>
													<span class="color-gold">&#9733;</span> <span
													class="color-gold">&#9733;</span>
												</span> | 작성날짜 : ${review.reviewDate}
    										</c:when>
											<c:when test="${review.rating == 4}">
												<span> <span class="color-gold">&#9733;</span> <span
													class="color-gold">&#9733;</span> <span class="color-gold">&#9733;</span>
													<span class="color-gold">&#9733;</span> <span>&#9734;</span>
												</span> | 작성날짜 : ${review.reviewDate}
    										</c:when>
											<c:when test="${review.rating == 3}">
												<span> <span class="color-gold">&#9733;</span> <span
													class="color-gold">&#9733;</span> <span class="color-gold">&#9733;</span>
													<span>&#9734;</span> <span>&#9734;</span>
												</span> | 작성날짜 : ${review.reviewDate}
    										</c:when>
											<c:when test="${review.rating == 2}">
												<span> <span class="color-gold">&#9733;</span> <span
													class="color-gold">&#9733;</span> <span>&#9734;</span> <span>&#9734;</span>
													<span>&#9734;</span>
												</span> | 작성날짜 : ${review.reviewDate}
    										</c:when>
											<c:when test="${review.rating == 1}">
												<span> <span class="color-gold">&#9733;</span> <span>&#9734;</span>
													<span>&#9734;</span> <span>&#9734;</span> <span>&#9734;</span>
												</span> | 작성날짜 : ${review.reviewDate}
    										</c:when>
											<c:otherwise>
												<span> <span>&#9734;</span> <span>&#9734;</span> <span>&#9734;</span>
													<span>&#9734;</span> <span>&#9734;</span>
												</span> | 작성날짜 : ${review.reviewDate}
    										</c:otherwise>
										</c:choose>
									</h4>
								</div>

								<div class="review-img-event-container">
									<div class="img-slide">
										<c:forEach var="img" items="${review.reviewImgList }">
											<img
												src="${img.reviewImgUrl}/${img.reviewImgSaveName }${img.reviewImgExtension}">
										</c:forEach>
									</div>
								</div>

								<p class="review-text-box">${review.reviewText }</p>
								<div class="more-text display-none">
									더보기<i class="fa-solid fa-chevron-down"></i>
								</div>
								<div class="review-btn">
									<button type="button" class="write-review-popup-btn"
										data-review-code="${review.reviewCode}">리뷰 수정</button>
									<button type="button"
										onclick="location.href='/mypage/removeReview?reviewCode=${review.reviewCode}'">리뷰
										삭제</button>
								</div>
							</div>
						</div>
						<c:if test="${review.replyExists == '1' }">
							<div class="reply-box">
								<div class="reply-line"></div>
								<div class="reply-text-container">
									<div>
										<h3>${review.acmName} 사장님답변</h3>
										<h3>|</h3>
										<h4>작성날짜 : ${review.reply.replyDate }</h4>

									</div>
									<p>${review.reply.replyText }</p>
									<div class="more-text display-none">
										더보기<i class="fa-solid fa-chevron-down"></i>
									</div>
								</div>
							</div>
						</c:if>
					</c:forEach>

				</div>
			</div>
		</div>
	</div>
	<script src="/js/customer/customer_mypage_review.js"></script>
</body>
</html>
