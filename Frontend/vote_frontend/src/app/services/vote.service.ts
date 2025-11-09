import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Vote {
  id?: number;
  candidate: string;
}

@Injectable({
  providedIn: 'root'
})
export class VoteService {
  private apiUrl = 'https://vote-app-2q7ogwocpa-ew.a.run.app';

  constructor(private http: HttpClient) {}

  getVotes(): Observable<Vote[]> {
  return this.http.get<Vote[]>(`${this.apiUrl}/votes`, {
    headers: { 'Cache-Control': 'no-store' }
  });
}

  addVote(vote: Vote): Observable<Vote> {
    return this.http.post<Vote>(`${this.apiUrl}/vote`, vote);
  }
}
